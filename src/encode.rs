use std::fs;
use base64::{engine::general_purpose, Engine};
use image::{ImageBuffer, Rgba};

pub struct EncodedImage {
    pub chunks: Vec<String>,
}

pub fn encode_png(path: &str) -> EncodedImage {
    let bytes = fs::read(path).expect("cannot read PNG");
    let img = image::load_from_memory(&bytes).expect("cannot decode PNG");
    let mut rgba = img.to_rgba8();

    // pink/maroon accent tokyo night
    let tint_r: f32 = 255.0;
    let tint_g: f32 = 100.0;
    let tint_b: f32 = 140.0;

    for pixel in rgba.pixels_mut() {
        let a = pixel[3] as f32 / 255.0;  // original alpha
        if a > 0.01 {
            // blend pixel color toward tint, keep structure visible
            pixel[0] = (pixel[0] as f32 * 0.3 + tint_r * 0.7) as u8;
            pixel[1] = (pixel[1] as f32 * 0.3 + tint_g * 0.7) as u8;
            pixel[2] = (pixel[2] as f32 * 0.3 + tint_b * 0.7) as u8;
            // opacity
            pixel[3] = (a * 255.0 * 0.30) as u8;
        }
    }

    // encode modified image back to PNG bytes
    let mut buf = std::io::Cursor::new(Vec::new());
    rgba.write_to(&mut buf, image::ImageFormat::Png).expect("cannot encode PNG");
    let encoded = general_purpose::STANDARD.encode(buf.get_ref());

    let chunks: Vec<String> = encoded
        .as_bytes()
        .chunks(4096)
        .map(|c| String::from_utf8(c.to_vec()).unwrap())
        .collect();

    EncodedImage { chunks }
}

pub fn save_tinted(path: &str, out_path: &str) {
    let bytes = std::fs::read(path).expect("cannot read PNG");
    let img = image::load_from_memory(&bytes).expect("cannot decode PNG");
    let mut rgba = img.to_rgba8();

    let tint_r: f32 = 255.0;
    let tint_g: f32 = 100.0;
    let tint_b: f32 = 140.0;

    for pixel in rgba.pixels_mut() {
        let a = pixel[3] as f32 / 255.0;
        if a > 0.01 {
            pixel[0] = (pixel[0] as f32 * 0.3 + tint_r * 0.7) as u8;
            pixel[1] = (pixel[1] as f32 * 0.3 + tint_g * 0.7) as u8;
            pixel[2] = (pixel[2] as f32 * 0.3 + tint_b * 0.7) as u8;
            pixel[3] = (a * 255.0 * 0.30) as u8;
        }
    }

    let mut buf = std::io::Cursor::new(Vec::new());
    rgba.write_to(&mut buf, image::ImageFormat::Png).unwrap();
    std::fs::write(out_path, buf.get_ref()).unwrap();
}
