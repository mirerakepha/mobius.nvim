use serde::Deserialize;
use std::fs;

#[derive(Deserialize)]
pub struct Config{
    pub tint: Tint,
    pub position: Position,
}

#[derive(Deserialize)]
pub struct Tint {
    pub r: f32,
    pub g: f32,
    pub b: f32,
    pub opacity: f32,
}

#[derive(Deserialize)]
pub struct Position {
    pub pad_right: u16,
    pub pad_bottom: u16,
}

impl Default for Config {
    fn default() -> Self {
        Config {
            tint: Tint {
                r: 255.0, g: 100.0, b: 140.0, opacity: 0.65,
            },
            position: Position {
                pad_right: 12, pad_bottom: 6,
            },
        }
    }
}

pub fn load() -> Config {
    let path = dirs_next::config_dir()
        .map(|d| d.join("mobius/mobius.toml"));

    if let Some(p) = path {
        if p.exists() {
            let content = fs::read_to_string(&p)
                .unwrap_or_default();
            return toml::from_str(&content)
                .unwrap_or_default();
        }
    }
    Config::default()
}
