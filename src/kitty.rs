use crate::encode::EncodedImage;
use std::fs::OpenOptions;
use std::io::{Write, BufWriter};

pub fn transmit_and_place(img: &EncodedImage, _image_id: u32, col: u16, row: u16) {
    let tty = OpenOptions::new()
        .write(true)
        .open("/dev/tty")
        .expect("cannot open /dev/tty");
    let mut out = BufWriter::new(tty);

    // position cursor
    write!(out, "\x1b[{};{}H", row, col).unwrap();

    let total = img.chunks.len();
    for (i, chunk) in img.chunks.iter().enumerate() {
        let is_last = i == total - 1;
        let m = if is_last { 0 } else { 1 };

        if i == 0 {
            write!(
                out,
                "\x1b_Ga=T,f=100,C=1,q=2,m={};{}\x1b\\",
                m, chunk
            ).unwrap();
        } else {
            write!(out, "\x1b_Gm={};{}\x1b\\", m, chunk).unwrap();
        }
    }

    out.flush().unwrap();
}
