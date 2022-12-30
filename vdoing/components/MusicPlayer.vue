<template>
    <div class="player">
        <div class="player__header">
            <div class="player__img player__img--absolute slider">
                <button class="player__button player__button--absolute--nw playlist" @click="closePlayer">
                    <img src="@theme/assets/svg/playlist.svg" alt="playlist-icon">
                </button>
                <button class="player__button player__button--absolute--center play" @click="paly">
                    <img src="@theme/assets/svg/play.svg" alt="play-icon">
                    <img src="@theme/assets/svg/pause.svg" alt="pause-icon">
                </button>
                <div class="slider__content">
                    <img class="img slider__img" src="@theme/assets/img/1.jpg" alt="cover">
                    <img class="img slider__img" src="@theme/assets/img/2.jpg" alt="cover">
                    <img class="img slider__img" src="@theme/assets/img/3.jpg" alt="cover">
                    <img class="img slider__img" src="@theme/assets/img/4.jpg" alt="cover">
                    <img class="img slider__img" src="@theme/assets/img/5.jpg" alt="cover">
                    <img class="img slider__img" src="@theme/assets/img/6.jpg" alt="cover">
                    <img class="img slider__img" src="@theme/assets/img/7.jpg" alt="cover">
                </div>
            </div>
            <div class="player__controls">
                <button class="player__button back" @click="back">
                    <img class="img" src="@theme/assets/svg/back.svg" alt="back-icon">
                </button>
                <p class="player__context slider__context" @click="openPlayer" @animationend="contextAnima">
                    <strong class="slider__name"></strong>
                    <span class="player__title slider__title"></span>
                </p>
                <button class="player__button next" @click="next">
                    <img class="img" src="@theme/assets/svg/next.svg" alt="next-icon">
                </button>
                <div class="progres" @mousedown="progresMouseDown">
                    <div class="progres__filled"></div>
                </div>
            </div>
        </div>
        <ul class="player__playlist list">
            <li class="player__song">
                <img class="player__img img" src="@theme/assets/img/2.jpg" alt="cover">
                <p class="player__context">
                    <b class="player__song-name">blinding lights</b>
                    <span class="flex">
                        <span class="player__title">the weeknd</span>
                        <span class="player__song-time"></span>
                    </span>
                </p>
                <audio class="audio" src="https://physical-authority.surge.sh/music/2.mp3"></audio>
            </li>
            <li class="player__song">
                <img class="player__img img" src="@theme/assets/img/3.jpg" alt="cover">
                <p class="player__context">
                    <b class="player__song-name">джованна</b>
                    <span class="flex">
                        <span class="player__title">enrasta</span>
                        <span class="player__song-time"></span>
                    </span>
                </p>
                <audio class="audio" src="https://physical-authority.surge.sh/music/3.mp3"></audio>
            </li>
            <li class="player__song">
                <img class="player__img img" src="@theme/assets/img/4.jpg" alt="cover">
                <p class="player__context">
                    <b class="player__song-name">a man</b>
                    <span class="flex">
                        <span class="player__title">travis scott</span>
                        <span class="player__song-time"></span>
                    </span>
                </p>
                <audio class="audio" src="https://physical-authority.surge.sh/music/4.mp3"></audio>
            </li>
            <li class="player__song">
                <img class="player__img img" src="@theme/assets/img/5.jpg" alt="cover">
                <p class="player__context ">
                    <b class="player__song-name">unforgetting</b>
                    <span class="flex">
                        <span class="player__title">zaxx</span>
                        <span class="player__song-time"></span>
                    </span>
                </p>
                <audio class="audio" src="https://physical-authority.surge.sh/music/5.mp3"></audio>
            </li>
            <li class="player__song">
                <img class="player__img img" src="@theme/assets/img/6.jpg" alt="cover">
                <p class="player__context">
                    <b class="player__song-name">waharan</b>
                    <span class="flex">
                        <span class="player__title">Randall</span>
                        <span class="player__song-time"></span>
                    </span>
                </p>
                <audio class="audio" src="https://physical-authority.surge.sh/music/6.mp3"></audio>
            </li>
            <li class="player__song">
                <img class="player__img img" src="@theme/assets/img/7.jpg" alt="cover">
                <p class="player__context ">
                    <b class="player__song-name">starlight feat mr gabriel <span class="uppercase">4am</span> remix</b>
                    <span class="flex">
                        <span class="player__title">jai wolf</span>
                        <span class="player__song-time"></span>
                    </span>
                </p>
                <audio class="audio" src="https://physical-authority.surge.sh/music/7.mp3"></audio>
            </li>
        </ul>
    </div>
</template>

<script>
import '../styles/style.css';

// 计算音频的时长
const countAudioTime = async (audio) => {
    while (isNaN(audio.duration) || audio.duration === Infinity) {
        // 延迟一会 不然网页都卡死
        await new Promise(resolve => setTimeout(resolve, 100));
        // 设置随机播放时间，模拟调进度条
        audio.currentTime = 10000000 * Math.random();
    }
    audio.currentTime = 0;
    return audio.duration;
}

export default {
    mixins: [{ countAudioTime }],
    data() {
        return {
            left: 0,
            isMove: false,
            isPlay: false,
            count: 0,
            sliderWidth: 100,
            song: null,
        }
    },
    mounted: function () {
        const player = document.querySelector(".player");
        const playerSongs = player.querySelectorAll(".audio");
        const sliderContext = player.querySelector(".slider__context");

        this.song = playerSongs[0];
        playerSongs.forEach(song => {
            countAudioTime(song).then(res => {
                song.addEventListener("loadeddata", this.durationSongs(song));
                song.addEventListener("timeupdate", this.progresUpdate);
            });
        });

        sliderContext.addEventListener("animationend", () => sliderContext.style.animationName = '');

        this.changeSliderContext();

        document.addEventListener("mousemove", (e) => {
            return this.isMove && this.scurb(e);
        });

        document.addEventListener("mouseup", () => {
            this.isMove = false
            this.song.muted = false;
        });

        document.ondragstart = () => {
            return false
        };
    },
    methods: {
        scurb(e) {
            const player = document.querySelector(".player");
            const progres = player.querySelector(".progres");
            const progresFilled = progres.querySelector(".progres__filled");

            // If we use e.offsetX, we have trouble setting the song time, when the mousemove is running
            const currentTime = ((e.clientX - progres.getBoundingClientRect().left) / progres.offsetWidth) * this.song.duration;
            this.song.currentTime = currentTime;

            const progresFilledWidth = (this.song.currentTime / this.song.duration) * 100 + "%";
            progresFilled.style.width = progresFilledWidth;

        },
        progresMouseDown(e) {
            this.scurb(e);
            this.isMove = true;
            this.song.muted = true;
        },
        progresUpdate() {
            const player = document.querySelector(".player");
            const progres = player.querySelector(".progres");
            const progresFilled = progres.querySelector(".progres__filled");
            const playerPlayList = player.querySelectorAll(".player__song");
            const playButton = player.querySelector(".play");
            const pauseIcon = playButton.querySelector("img[alt = 'pause-icon']");
            const playIcon = playButton.querySelector("img[alt = 'play-icon']");
            const sliderContentLength = playerPlayList.length - 1;

            if (this.song == null || this.song.duration == null) {
                return;
            }

            const progresFilledWidth = (this.song.currentTime / this.song.duration) * 100 + "%";
            progresFilled.style.width = progresFilledWidth;

            if (this.song.duration == this.song.currentTime) {
                this.next();
            }
            if (this.count == sliderContentLength && this.song.currentTime == this.song.duration) {
                playIcon.style.display = "block";
                pauseIcon.style.display = "";
                this.isPlay = false;
            }
        },
        // 加载歌曲的时间
        durationSongs(song) {
            let min = parseInt(song.duration / 60);
            if (min < 10) min = "0" + min;

            let sec = parseInt(song.duration % 60);
            if (sec < 10) sec = "0" + sec;

            const playerSongTime = `${min}:${sec}`;
            song.closest(".player__song").querySelector(".player__song-time").append(playerSongTime);

        },
        contextAnima() {
            const player = document.querySelector(".player");
            const sliderContext = player.querySelector(".slider__context");
            sliderContext.style.animationName = '';
        },
        openPlayer() {
            const player = document.querySelector(".player");
            const playerHeader = player.querySelector(".player__header");
            const playerControls = player.querySelector(".player__controls");
            const slider = player.querySelector(".slider");

            playerHeader.classList.add("open-header");
            playerControls.classList.add("move");
            slider.classList.add("open-slider");
        },
        closePlayer() {
            const player = document.querySelector(".player");
            const playerHeader = player.querySelector(".player__header");
            const playerControls = player.querySelector(".player__controls");
            const slider = player.querySelector(".slider");

            playerHeader.classList.remove("open-header");
            playerControls.classList.remove("move");
            slider.classList.remove("open-slider");

        },
        back() {
            const player = document.querySelector(".player");
            const slider = player.querySelector(".slider");
            const sliderContent = slider.querySelector(".slider__content");
            if (this.count == 0) {
                this.count = this.count
                return
            }

            this.left -= this.sliderWidth;
            this.left = Math.max(0, this.left);
            sliderContent.style.transform = `translate3d(-${this.left}%, 0, 0)`;
            this.count--;

            this.changeSliderContext();
            this.selectSong();
        },
        next() {
            const player = document.querySelector(".player");
            const slider = player.querySelector(".slider");
            const playerPlayList = player.querySelectorAll(".player__song");
            const sliderContent = slider.querySelector(".slider__content");
            const sliderContentLength = playerPlayList.length - 1;

            if (this.count == sliderContentLength) {
                this.count = this.count;
                return
            }

            this.left += this.sliderWidth;
            this.left = Math.min(this.left, (sliderContentLength) * this.sliderWidth);
            sliderContent.style.transform = `translate3d(-${this.left}%, 0, 0)`;
            this.count++;

            this.changeSliderContext();
            this.selectSong();
        },
        changeSliderContext() {
            const player = document.querySelector(".player");
            const sliderContext = player.querySelector(".slider__context");
            const sliderName = sliderContext.querySelector(".slider__name");
            const sliderTitle = sliderContext.querySelector(".slider__title");
            const playerPlayList = player.querySelectorAll(".player__song");

            sliderContext.style.animationName = "opacity";

            sliderName.textContent = playerPlayList[this.count].querySelector(".player__title").textContent;
            sliderTitle.textContent = playerPlayList[this.count].querySelector(".player__song-name").textContent;

            if (sliderName.textContent.length > 16) {
                const textWrap = document.createElement("span");
                textWrap.className = "text-wrap";
                textWrap.innerHTML = sliderName.textContent + "   " + sliderName.textContent;
                sliderName.innerHTML = "";
                sliderName.append(textWrap);

            }

            if (sliderTitle.textContent.length >= 18) {
                const textWrap = document.createElement("span");
                textWrap.className = "text-wrap";
                textWrap.innerHTML = sliderTitle.textContent + "    " + sliderTitle.textContent;
                sliderTitle.innerHTML = "";
                sliderTitle.append(textWrap);
            }

        },
        selectSong() {
            const player = document.querySelector(".player");
            const playerSongs = player.querySelectorAll(".audio");
            this.song = playerSongs[this.count];
            for (const item of playerSongs) {
                if (item != this.song) {
                    item.pause();
                    item.currentTime = 0;
                }
            }
            if (this.isPlay) this.song.play();
        },
        paly() {
            this.isPlay = true;
            this.playSong();
        },
        playSong() {
            const player = document.querySelector(".player");
            const playButton = player.querySelector(".play");
            const pauseIcon = playButton.querySelector("img[alt = 'pause-icon']");
            const playIcon = playButton.querySelector("img[alt = 'play-icon']");
            // const playerSongs = player.querySelectorAll(".audio");

            // let song = playerSongs[this.count];

            if (this.song.paused) {
                this.song.play();
                playIcon.style.display = "none";
                pauseIcon.style.display = "block";
            } else {
                this.song.pause();
                this.isPlay = false;
                playIcon.style.display = "";
                pauseIcon.style.display = "";
            }
        }
    }
}

</script>

