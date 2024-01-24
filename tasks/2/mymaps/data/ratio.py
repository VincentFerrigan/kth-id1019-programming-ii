import csv

def read_data(filename, operation):
    if operation == "add":
        col = 1
    elif operation == "lookup":
        col = 2
    elif operation == "remove":
        col = 3

    with open(filename, 'r') as file:
        reader = csv.reader(file, delimiter=' ')
        next(reader)  # Skip header
        return {int(rows[0]): float(rows[col]) for rows in reader}

def calculate_ratios(data1, data2):
    return {size: (data1[size] / data2[size] if size in data2 and data2[size] != 0 else 0)
            for size in data1}

def write_combined_data_to_file(list_data, tree_data, map_data, ratios_tl, ratios_lm, ratios_tm, operation, output_file):
    cap_op = operation[0].upper() + operation[1:]
    with open(output_file, 'w') as file:
        writer = csv.writer(file, delimiter=' ')
        writer.writerow(['Size', 'List {0}'.format(cap_op), 'Tree {0}'.format(cap_op), 'Map {0}'.format(cap_op),
                         'Tree/List Ratio', 'List/Map Ratio', 'Tree/Map Ratio'])

        sizes = set(list_data.keys()) | set(tree_data.keys()) | set(map_data.keys())
        for size in sorted(sizes):
            writer.writerow([
                size,
                list_data.get(size, 0),
                tree_data.get(size, 0),
                map_data.get(size, 0),
                ratios_tl.get(size, 0),
                ratios_lm.get(size, 0),
                ratios_tm.get(size, 0)
            ])
def write_combined_ratios_to_files_per_operation(operation):
    # Read data from files
    list_data = read_data('list.dat', operation)
    tree_data = read_data('tree.dat', operation)
    map_data = read_data('map.dat', operation)

    # Calculate ratios
    ratios_tree_list = calculate_ratios(tree_data, list_data)
    ratios_list_map = calculate_ratios(list_data, map_data)
    ratios_tree_map = calculate_ratios(tree_data, map_data)

    # Write combined data to a new file
    write_combined_data_to_file(list_data, tree_data, map_data, ratios_tree_list, ratios_list_map, ratios_tree_map,
                                operation, 'combined_{0}_ratios.dat'.format(operation))

write_combined_ratios_to_files_per_operation("add")
write_combined_ratios_to_files_per_operation("lookup")
write_combined_ratios_to_files_per_operation("remove")
