import 'package:flutter/material.dart';

class DrawerItem {
  final IconData icon;
  final String titulo;
  const DrawerItem({@required this.icon, @required this.titulo});
}

class DrawerItems {
  static const pedidos = DrawerItem(icon: Icons.shopping_cart, titulo: 'Pedidos');
  static const productos = DrawerItem(icon: Icons.food_bank, titulo: 'Productos');
  static const mesas = DrawerItem(icon: Icons.dinner_dining, titulo: 'Mesas');
  static const ventas = DrawerItem(icon: Icons.money, titulo: 'Ventas');
  static const reportes = DrawerItem(icon: Icons.report, titulo: 'Reportes');

  static final List<DrawerItem> menu = [pedidos, productos, mesas, ventas, reportes];
}
