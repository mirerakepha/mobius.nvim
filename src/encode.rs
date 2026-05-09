use base64::{engine::general_purpose, Engine};
use image::{imageops::FilterType, GenericImageView};

pub struct EncodedImage {
    pub chunks: Vec<String>,
    pub width: u32,
    pub height: u32,
}

pub fn encode_png(path: &str, cell_w: u32, cell_h: u32) -> EncodedImage {

    let img = image::open(path).expect("Cannot Open Image");

    // 6 terminal cells wide & keep aspect ratio
    let target_px_w = cell_w * 6;
    let target_px_h = cell_h * 6;
    let resized = img.resize(target_px_w, target_px_h, FilterType::Lanczos3);

    let (w, h) = resized.dimensions();
}
