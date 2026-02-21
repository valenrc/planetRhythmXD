#!/usr/bin/env python3
import argparse
import csv
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


def process_csv(input_csv: Path) -> Path:
    if not input_csv.exists():
        raise FileNotFoundError(f"No existe el archivo: {input_csv}")

    output_csv = input_csv.with_name(f"{input_csv.stem}_processed.csv")

    with input_csv.open("r", encoding="utf-8", newline="") as infile:
        reader = csv.DictReader(infile)
        expected_fields = ["id", "type", "timing"]

        if reader.fieldnames != expected_fields:
            raise ValueError(
                "Cabecera inválida. Se esperaba exactamente: id,type,timing"
            )

        rows = []
        for index, row in enumerate(reader, start=2):
            try:
                row["timing"] = timing_to_milliseconds(row["timing"])
            except Exception as exc:
                raise ValueError(f"Error en línea {index}: {exc}") from exc
            rows.append(row)

    with output_csv.open("w", encoding="utf-8", newline="") as outfile:
        writer = csv.DictWriter(outfile, fieldnames=["id", "type", "timing"])
        writer.writeheader()
        writer.writerows(rows)

    return output_csv


def main() -> None:
    parser = argparse.ArgumentParser(
        description=(
            "Convierte la columna timing (formato mm:ss:mm) a milisegundos totales "
            "y guarda el resultado en <nombre>_processed.csv"
        )
    )
    parser.add_argument("csv_path", help="Ruta al archivo CSV de entrada")
    args = parser.parse_args()

    input_csv = Path(args.csv_path)
    output_csv = process_csv(input_csv)
    print(f"Archivo procesado: {output_csv}")


if __name__ == "__main__":
    main()
