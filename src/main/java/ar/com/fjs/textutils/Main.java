package ar.com.fjs.textutils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Properties;
import java.util.Scanner;

public class Main {
	Properties properties = new Properties();

	public static void main(String[] args) {
		Main m = new Main();
		m.process();
	}
	
	public void loadProperties() {
		InputStream input;
		try {
			input = getClass().getResourceAsStream("/config.properties");
			properties.load(input);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void process() {
		int countTables = 0;
		int countViews = 0;
		int countStoredProcedures = 0;
		int totalLines = 0;
		boolean processing = false;
		File file = null;
		
		loadProperties();

		InputStream in = getClass().getResourceAsStream("/objetos-sabed.sql");
		BufferedReader reader = new BufferedReader(new InputStreamReader(in));
		BufferedWriter writer = null;

		try (Scanner scanner = new Scanner(reader)) {
			while (scanner.hasNextLine()) {
				String line = scanner.nextLine();
				totalLines++;

				if (line.contains("-- DDL for Table")) {
					if (processing) {
						try {
							writer.close();
							processing = false;
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
					countTables++;
					file = createFile(properties.getProperty("tables.destination"), line);
					try {
						writer = new BufferedWriter(new FileWriter(file));
						processing = true;
					} catch (IOException e) {
						e.printStackTrace();
					}
				} else if (line.contains("-- DDL for View")) {
					if (processing) {
						try {
							writer.close();
							processing = false;
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
					countViews++;
					file = createFile(properties.getProperty("views.destination"), line);
					try {
						writer = new BufferedWriter(new FileWriter(file));
						processing = true;
					} catch (IOException e) {
						e.printStackTrace();
					}
				} else if (line.contains("-- DDL for Stored Procedure")) {
					if (processing) {
						try {
							writer.close();
							processing = false;
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
					countStoredProcedures++;
					file = createFile(properties.getProperty("sps.destination"), line);
					try {
						writer = new BufferedWriter(new FileWriter(file));
						processing = true;
					} catch (IOException e) {
						e.printStackTrace();
					}
				} else {
					if (writer != null) {
						try {
							writer.write(line + "\n");
						} catch (IOException e) {
							e.printStackTrace();
						}
					} else {
						if (processing) {
							try {
								writer = new BufferedWriter(new FileWriter(file));
								processing = true;
							} catch (IOException e) {
								e.printStackTrace();
							}
						}
					}
				}
			}
		}
		if (processing) {
			try {
				writer.close();
				processing = false;
				System.out.println("Se fuerza el cierre!");
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		System.out.format("Hecho. Total de lineas leídas: %d", totalLines);
		System.out.println();
		System.out.format("Encontrados: %d tablas, %d vistas y %d stored procedures.", countTables, countViews,
				countStoredProcedures);
	}

	private File createFile(String destination, String text) {
		File file = new File(destination + getName(text) + ".sql");
		try {
			if (file.createNewFile()) {
				System.out.println("File is created: " + file.getAbsoluteFile());
			} else {
				System.out.println("File already exists.");
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return file;
	}

	private String getName(String text) {
		int beginIndex = text.indexOf("'");
		int endIndex = text.indexOf("'", beginIndex + 1);
		String fileName = text.substring(beginIndex + 1, endIndex);
		return fileName;
	}
}
