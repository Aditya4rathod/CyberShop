import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title, description;
  final String images;
  final double price;
  final bool isFavourite;
  final String brand;

  Product( {
    required this.id,
    required this.images,
    this.isFavourite = false,
    required this.title,
    required this.price,
    required this.description,
  required this.brand,
  });
}

// Our demo Products

List<Product> demoProducts = [
  Product(
    id: 1,
    images: 'assets/images/iphone1.jpg',
    title: "I phone 14",
    price: 70000,
    description: description,
    isFavourite: false,
    brand: 'apple',
  ),
  Product(
    id: 2,
    images:'assets/images/nothing_1.jpg',
    title: "Nothing Phone 1",
    price: 35000,
    description: description,
    isFavourite: false,
    brand: 'Nothing',
  ),
  Product(
    id: 3,
    images: 'assets/images/samsung_1.jpg',
    title: "Galaxy S23",
    price: 100000,
    description: description,
    isFavourite: false,
    brand: 'samsung',

  ),
  Product(
    id: 4,
    images: 'assets/images/one_pluse_1.jpg',
    title: "OnePlus 11R",
    price: 50000,
    description: description,
    isFavourite: false,
    brand: 'OnePlus',
  ),
  Product(
    id: 5,
    images:'assets/images/one_pluse2T_1.jpg',
    title: "Nord 2T",
    price: 28000,
    description: description,
    isFavourite: false,
    brand: 'OnePlus',
  ),
];

const String description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
