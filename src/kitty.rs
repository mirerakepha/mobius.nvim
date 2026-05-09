use crate::encode::EncodeImage;
use std::io::{self, Write};

pub fn transmit_and_place(img: &EncodedImage, image_id: u32, col: u16, row: u16) {
    let stdout = io::stdout();
    let mut out = stdout.lock();

    let total = img.chunks.len();
    for (i, chunk) in img.chunks.iter().enumerate() {
        let is_last = i == total - 1;
        let m = if is_last { 0 } else { 1 };

        if i = 0 {
            // First chunk carries all metadata
            // f=32 = RGBA raw pixels, s=width, v=height, i=image_id
            // q=2 = suppress all responses
            // C=1 = do not move cursor after transmission
            write!(out,
                "\x1b_Ga=T,f=32,s={},v={},i={},q=2,C=1,m={};{}\x1b\\",
                img.width, img.height, img_id, m, chunk
            ).unwrap();

        } else {
            write!(out, "\x1b_Gm={};{}\x1b\\", m, chunk).unwrap();
        }
    }

    // Separate placement command: position at (col, row), z=-1 (below text)
    // X/Y are 1-based column/row in terminal cells
    write!(
        out,
        "\x1b_Ga=p,i={},p=1,X={},Y={},z=-1,q=2\x1b\\",
        image_id, col, row
    ).unwrap();

    out.flush().unwrap();
}
