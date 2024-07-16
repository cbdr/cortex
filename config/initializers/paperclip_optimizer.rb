Paperclip::PaperclipOptimizer.default_options = {
  allow_lossy: true,
  skip_missing_workers: false,
  verbose: true,
  jpegoptim: {
    allow_lossy: true,
    strip: :all,
    max_quality: 90
  },
  advpng: false,
  gifsicle: {
    interlace: true
  },
  jhead: false,
  jpegrecompress: false,
  jpegtran: false,
  optipng: false,
  pngcrush: false,
  pngout: false,
  oxipng: false,
  pngquant: {
    allow_lossy: true,
    quality: 33..50,
    speed: 3
  },
  svgo: false  
}
