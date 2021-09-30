import 'package:billing_application/data/data.dart';
import 'package:flutter/material.dart';

// class EditInformation extends StatefulWidget {
//   const EditInformation({Key? key}) : super(key: key);
//
//   @override
//   _EditInformationState createState() => _EditInformationState();
// }
//
// class _EditInformationState extends State<EditInformation> {
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _priceController = TextEditingController();
//   TextEditingController _imageController = TextEditingController();
//   TextEditingController _costController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           TextField(
//             decoration: InputDecoration(hintText: "Name"),
//             controller: _nameController,
//           ),
//           TextField(
//             decoration: InputDecoration(hintText: "Price"),
//             controller: _priceController,
//           ),
//           TextField(
//             decoration: InputDecoration(hintText: "Image"),
//             controller: _imageController,
//           ),
//           TextField(
//             decoration: InputDecoration(hintText: "cost"),
//             controller: _costController,
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 /*Data data = Data();
//                 data.itemName.add(_nameController.text);
//                 data.itemPrice.add(1.2);
//                 data.itemImage.add(_imageController.text);
//                 data.itemCount.add(0);
//                 data.cost.add(0.0);*/
//               },
//               child: Text("Submit"))
//         ],
//       ),
//     );
//   }
// }

class EditInformation extends StatelessWidget {
  const EditInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('assets/Images/404.png'),
    );
  }
}
