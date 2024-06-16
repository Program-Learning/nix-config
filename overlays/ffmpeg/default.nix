_: (_: super: rec {
  ffmpeg-full = super.ffmpeg-full.override {
    withV4l2 = true;
    withV4l2M2m = true;
  };

  ffmpeg = super.ffmpeg.override {
    withV4l2 = true;
    withV4l2M2m = true;
  };
})
