mod encode;
mod kitty;
use clap::Parser;

#[derive(Parser)]
struct Args {
    #[arg(long)] png:      String,   // absolute path to logo PNG
    #[arg(long)] id:       u32,      // unique image id
    #[arg(long)] col:      u16,      // terminal column to place at
    #[arg(long)] row:      u16,      // terminal row to place at
    #[arg(long)] cell_w:   u32,      // terminal cell width in px
    #[arg(long)] cell_h:   u32,      // terminal cell height in px

}

fn main() {

    let args = Args::parse();
    
    let img = encode::encode_png(&args.png, args.cell_w, args.cell_h);
    
    kitty::transmit_and_place(&img, args.id, args.col, args.row);
    
}
