
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


class FileController extends GetxController{

  File? selectedIFile;
  var filePath=''.obs;
  var fileName=''.obs;
  var type=''.obs;
  var getFilePath=''.obs;

  var selectedFiles = <File>[].obs;  // Observable list of selected files
  var selectedFilePaths = <String>[].obs;

  // var selectedFilePath = ''.obs;
  // File? selectedFile;


 /* Future<void> pickImageFile() async {
    try {
      // Let the user pick multiple files (images or PDFs)
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,  // Allows selecting multiple files
        type: FileType.image,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.isNotEmpty) {
        selectedFiles.clear();  // Clear previous selection
        selectedFilePaths.clear();  // Clear previous file paths

        for (PlatformFile file in result.files) {
          if (file.path != null) {
            File selectedFile = File(file.path!);
            selectedFiles.add(selectedFile);  // Add file to the list
            selectedFilePaths.add(selectedFile.path);  // Add file path to the list
            String fileExtension = extension(selectedFile.path).toLowerCase();
            if (fileExtension == '.pdf') {
              print("Selected PDF: ${selectedFile.path}");
              // Handle PDF specific logic here
            } else if (fileExtension == '.jpg' || fileExtension == '.jpeg' || fileExtension == '.png') {
              print("Selected Image: ${selectedFile.path}");
              // Handle image-specific logic here
            } else {
              print("Unsupported file type selected.");
            }
          }

          print('Total File>>>${selectedFilePaths}');
        }

        // Optionally, you can call an upload function here for the selected files
        // uploadFiles(selectedFiles);

      } else {
        print("No files selected.");
      }
    } catch (e) {
      print("Error selecting files: $e");
    }
  }*/


  Future<void> pickImageFile() async {
    try {
      // Let the user pick image or PDF
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        selectedIFile = File(result.files.single.path!);
        filePath.value = selectedIFile!.path;

        String fileExtension = extension(selectedIFile!.path).toLowerCase();

        if (fileExtension == '.jpg' || fileExtension == '.jpeg' || fileExtension == '.png') {
          print("Selected Image: ${filePath.value}");
          getFilePath.value= filePath.value;
          Get.back();
          Get.snackbar('file selected', '');
         print("=========tap");

        } else {
          print("Unsupported file type selected.");
        }
        // You can call an upload function if needed
        // uploadFile(selectedFile!);

      } else {
        print("No file selected.");
      }
    } catch (e) {
      print("Error selecting file: $e");
    }
  }

  Future<void> pickFile() async {
    try {
      // Let the user pick image or PDF
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'heic', 'heif', 'mp4', 'avi', 'mkv', 'mov'],
      );

      if (result != null && result.files.single.path != null) {
        selectedIFile = File(result.files.single.path!);
        filePath.value = selectedIFile!.path;

        String fileExtension = extension(selectedIFile!.path).toLowerCase();

        if (fileExtension == '.pdf') {
          print("Selected PDF: ${filePath.value}");
           getFilePath.value= filePath.value;
           Get.back();
           Get.snackbar('file selected', '');
        } else if (fileExtension == '.jpg' || fileExtension == '.jpeg' || fileExtension == '.png') {
          print("Selected Image: ${filePath.value}");
          getFilePath.value= filePath.value;
          Get.back();
          Get.snackbar('file selected', '');
         print("=========tap");

        } else {
          print("Unsupported file type selected.");
        }
        // You can call an upload function if needed
        // uploadFile(selectedFile!);

      } else {
        print("No file selected.");
      }
    } catch (e) {
      print("Error selecting file: $e");
    }
  }


 /* Future<void> pickPDF() async {
    try {
      // Let the user pick a PDF file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],  // Only allows PDF files
      );

      if (result != null && result.files.single.path != null) {
        selectedIMage = File(result.files.single.path!);
        imagePath.value = selectedIMage!.path;
        fileName.value = basename(selectedIMage!.path);
        type.value='pdf';
        update();

        print("Selected PDF: ${fileName.value}");
        // Handle PDF specific logic here, such as uploading the PDF file

      } else {
        print("No PDF file selected.");
      }
    } catch (e) {
      print("Error picking PDF file: $e");
    }
  }*/


/// camera image
  Future pickImageFromCamera(ImageSource source) async {
    final returnImage = await ImagePicker().pickImage(source: source);
    if (returnImage == null) return;
    selectedIFile = File(returnImage.path);
    filePath.value=selectedIFile!.path;
     type.value='image';
    //  image = File(returnImage.path).readAsBytesSync();
    update();
    print('ImagesPath:$filePath');
    Get.back(); //
  }
  Future pickImageFromGallery() async {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    selectedIFile = File(returnImage.path);
    filePath.value=selectedIFile!.path;
     type.value='image';
    //  image = File(returnImage.path).readAsBytesSync();
    print('ImagesPath:$filePath');
    Get.back(); //
  }
}