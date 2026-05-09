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

    // Convert to rgba and apply opacity
    let mut rgba = resized.to_rgba8();
    for pixel in rgba.pixels_mut() {
        pixel[3] = (pixel[3] as f32 * 0.30) as u8;// 30% opacity
    } 

    let raw Vec<u8> = rgba.into_raw();
    let encoded = general_purpose::STANDARD::encode(&raw);

    // Chunk into <= 4096 byte pieces, each chunk length must be multiple of 4
    let chunks: Vec<String> = encoded
        .as_bytes()
        .chunks(4096)
        .map(|c| String::from_utf8(c.to_vec()).unwrap())
        .collect();

    EncodedImage { chunks, width: w, height: h }
}
