package main

import (
	"encoding/csv"
	"fmt"
	"io"
	"log"
	"os"
	"strings"
)

func newCSV(filename string) (*os.File, *csv.Reader, string) {
	file, err := os.Open(filename)
	if err != nil {
		log.Fatal(err)
		return nil, nil, ""
	}

	reader := csv.NewReader(file)

	headers, err := reader.Read()
	for i, h := range headers {
		headers[i] = fmt.Sprint("\"", h, "\"")
	}

	if err != nil {
		log.Fatal(err)
	}

	return file, reader, strings.Join(headers, ",")
}

func keepWhere(reader *csv.Reader, pred func([]string) bool) [][]string {
	lines := make([][]string, 0)
	for {
		record, err := reader.Read()
		if err != nil {
			if err == io.EOF {
				break
			}
			log.Fatal(err)

		}
		if pred(record) {
			lines = append(lines, record)
		}
	}
	return lines
}

func writeCSV(headers string, records [][]string, filename string) {
	file, err := os.Create(filename)
	if err != nil {
		log.Fatal(err)
		return
	}
	defer file.Close()

	_, err = io.WriteString(file, headers+"\n")
	if err != nil {
		log.Fatal(err)
		return
	}

	for _, record := range records {
		for i, field := range record {
			record[i] = fmt.Sprint("\"", field, "\"")
		}
		_, err = io.WriteString(file, strings.Join(record, ",")+"\n")
		if err != nil {
			log.Fatal(err)
			break
		}
	}
}

func main() {
	studentsFile, studentsReader, studentHeader := newCSV("db/csv/EN_BY_CLASS_ECMS-6384857.csv")
	defer studentsFile.Close()

	classesFile, classesReader, classesHeader := newCSV("db/csv/CLS_CMBND_SECT_FULL-6385825.csv")
	defer classesFile.Close()

	coursesFile, coursesReader, coursesHeader := newCSV("db/csv/CM_CRSE_CAT_ECMS-6383074.csv")
	defer coursesFile.Close()

	componentsFile, componentsReader, componentsHeader := newCSV("db/csv/CM_CRSE_CAT_ECMS_COMPONENTS-6383069.csv")
	defer componentsFile.Close()

	sessionsFile, sessionsReader, sessionsHeader := newCSV("db/csv/SPActivity_2017.csv")
	defer sessionsFile.Close()

	students := keepWhere(studentsReader, func(record []string) bool {
		return true
	})

	classes := keepWhere(classesReader, func(record []string) bool {
		for _, s := range students {
			if s[2] == record[3] {
				return true
			}
		}
		return false
	})

	courses := keepWhere(coursesReader, func(record []string) bool {
		for _, c := range classes {
			if c[1] == record[1] {
				return true
			}
		}
		return false
	})

	components := keepWhere(componentsReader, func(record []string) bool {
		for _, c := range courses {
			if c[1] == "00"+record[1] {
				return true
			}
		}
		return false
	})

	sessions := keepWhere(sessionsReader, func(record []string) bool {
		for _, c := range components {
			if strings.Contains(record[6], c[1]) {
				return true
			}
		}
		return false
	})

	writeCSV(studentHeader, students, "db/csv/EN_BY_CLASS_ECMS-6384857.min.csv")
	writeCSV(classesHeader, classes, "db/csv/CLS_CMBND_SECT_FULL-6385825.min.csv")
	writeCSV(coursesHeader, courses, "db/csv/CM_CRSE_CAT_ECMS-6383074.min.csv")
	writeCSV(componentsHeader, components, "db/csv/CM_CRSE_CAT_ECMS_COMPONENTS-6383069.min.csv")
	writeCSV(sessionsHeader, sessions, "db/csv/SPActivity_2017.min.csv")
}
