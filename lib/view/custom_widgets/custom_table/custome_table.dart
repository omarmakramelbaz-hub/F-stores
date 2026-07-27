import '../../../helpers/theme/app_colors.dart';
import '../../../helpers/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomAppTable extends StatefulWidget {
  const CustomAppTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onDeleteRow,
    // required this.cells,
  });

  final List<String> columns;
  final List<DataRow> rows;

  // final List<DataCell> cells;
  final void Function(int)? onDeleteRow;

  // Define the callback function

  @override
  State<CustomAppTable> createState() => _CustomAppTableState();
}

class _CustomAppTableState extends State<CustomAppTable> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return Theme.of(context).colorScheme.primary.withOpacity(0.8);
          }
          return AppColor.whiteColor(context); // Use the default value.
        }),
        // decoration: BoxDecoration(
        //     color: AppColor.greyColor(context).withOpacity(0.01),
        //    ),
        border: TableBorder.all(color: AppColor.greyColor(context).withOpacity(0.2), width: 1),
        dividerThickness: 0.5,
        headingTextStyle: AppTextStyle.text16MG(context),
        dataTextStyle: AppTextStyle.text16MG(context),
        columns: List.generate(
          widget.columns.length,
          (index) => DataColumn(label: Center(child: Text(widget.columns[index]))),
        ),
        rows: List.generate(widget.rows.length, (index) => DataRow(cells: widget.rows[index].cells)),
      ),
    );
  }
}
