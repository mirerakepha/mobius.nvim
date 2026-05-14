use crate::encode::EncodedImage;
use std::io::{self, Write};

pub fn transmit_and_place(img: &EncodedImage, _image_id: u32, col: u16, row: u16) {
    let stdout = io::stdout();
    let mut out = stdout.lock();

    // Move cursor to target position first
    // ESC[{row};{col}H  — positions cursor at row, col (1-based)
    write!(out, "\x1b[{};{}H", row, col).unwrap();

    let total = img.chunks.len();
    for (i, chunk) in img.chunks.iter().enumerate() {
        let is_last = i == total - 1;
        let m = if is_last { 0 } else { 1 };

        if i == 0 {
            // a=T = transmit and display immediately at current cursor position
            // f=32 = raw RGBA, s=width, v=height
            // C=1 = don't move cursor after display
            // q=2 = suppress terminal response
            write!(
                out,
                //"\x1b_Ga=T,f=32,s={},v={},C=1,q=2,m={};{}\x1b\\",
                "\x1b_Ga=T,f=100,C=1,q=2,m={};{}\x1b\\",
                /*img.width, img.height,*/ m, chunk
            )
            .unwrap();
        } else {
            write!(out, "\x1b_Gm={};{}\x1b\\", m, chunk).unwrap();
        }
    }

    out.flush().unwrap();
}
