#!/usr/bin/env python3
import argparse
from pathlib import Path


def timing_to_milliseconds(value: str) -> int:
    parts = value.strip().split(":")
    if len(parts) != 3:
        raise ValueError(f"Formato inválido de timing '{value}'. Se esperaba mm:ss:mm")

    minutes_str, seconds_str, millis_str = parts

    minutes = int(minutes_str)
    seconds = int(seconds_str)
    millis = int(millis_str)

    if minutes < 0 or seconds < 0 or millis < 0:
        raise ValueError(f"Timing inválido '{value}': no se permiten valores negativos")

    if seconds >= 60:
        raise ValueError(f"Timing inválido '{value}': los segundos deben ser menores a 60")

    return (minutes * 60 * 1000) + (seconds * 1000) + millis


def process_notes_line(line: str, line_number: int) -> str:
    stripped = line.strip()
    if not stripped:
        return line

    parts = [part.strip() for part in stripped.split(",")]
    if len(parts) != 3:
        raise ValueError(
            f"Error en línea {line_number}: formato de nota inválido. Se esperaba id,type,timing"
        )

    note_id, note_type, timing = parts
    timing_ms = timing_to_milliseconds(timing)
    return f"{note_id},{note_type},{timing_ms}\n"


def process_lvl(input_lvl: Path) -> Path:
    if not input_lvl.exists():
        raise FileNotFoundError(f"No existe el archivo: {input_lvl}")

    output_lvl = input_lvl.with_name(f"{input_lvl.stem}_processed.lvl")

    lines = input_lvl.read_text(encoding="utf-8").splitlines(keepends=True)

    in_notes = False
    found_notes_section = False
    processed_lines = []

    for line_number, line in enumerate(lines, start=1):
        stripped = line.strip()

        if stripped == "#NOTES":
            in_notes = True
            found_notes_section = True
            processed_lines.append(line)
            continue

        if stripped == "#ENDNOTES":
            in_notes = False
            processed_lines.append(line)
            continue

        if in_notes:
            processed_lines.append(process_notes_line(line, line_number))
        else:
            processed_lines.append(line)

    if not found_notes_section:
        raise ValueError("No se encontró la sección #NOTES en el archivo .lvl")

    output_lvl.write_text("".join(processed_lines), encoding="utf-8")
    return output_lvl


def main() -> None:
    parser = argparse.ArgumentParser(
        description=(
            "Convierte timings de la sección #NOTES (formato mm:ss:mm) a milisegundos "
            "totales y guarda en <nombre>_processed.lvl"
        )
    )
    parser.add_argument("lvl_path", help="Ruta al archivo .lvl de entrada")
    args = parser.parse_args()

    input_lvl = Path(args.lvl_path)
    output_lvl = process_lvl(input_lvl)
    print(f"Archivo procesado: {output_lvl}")


if __name__ == "__main__":
    main()
