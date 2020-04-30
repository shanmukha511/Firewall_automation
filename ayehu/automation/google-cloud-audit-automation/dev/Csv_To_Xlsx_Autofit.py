def csv_to_excel():
    import csv
    import os
    from glob import glob
    from xlsxwriter.workbook import Workbook
    for csvfile in glob('./*.csv'):
        name = os.path.basename(csvfile).split('.')[-2]
        workbook = Workbook('./' + str(name) + '.xlsx',
                            {'strings_to_numbers': True,
                            'constant_memory': True})
        worksheet = workbook.add_worksheet()
        with open(csvfile, 'r') as f:
            r = csv.reader(f)
            for (row_index, row) in enumerate(r):
                for (col_index, data) in enumerate(row):
                    worksheet.write(row_index, col_index, data)
            workbook.close()

def Excel_autofit():
    import openpyxl
    from string import ascii_uppercase
    from glob import glob
    for file in glob('./*.xlsx'):
        wb = openpyxl.load_workbook(filename=file)
        worksheet = wb.active
        for col in worksheet.columns:
          max_length = 0
          column = col[0].column
          for cell in col:
            try:  # Necessary to avoid error on empty cells
              if len(str(cell.value)) > max_length:
                max_length = len(cell.value)
            except:
              pass
          adjusted_width = max_length
          worksheet.column_dimensions[column].width = adjusted_width
        wb.save(file)

csv_to_excel()
Excel_autofit()
