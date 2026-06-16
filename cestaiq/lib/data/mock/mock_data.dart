import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/supermarket.dart';
import '../models/price.dart';

class MockData {
  // ─── SUPERMERCADOS ───────────────────────────────────────────────────────────

  static const List<Supermarket> supermarkets = [
    Supermarket(id: 'mercadona', name: 'Mercadona', color: Color(0xFF007940)),
    Supermarket(id: 'carrefour', name: 'Carrefour', color: Color(0xFF004A97)),
    Supermarket(id: 'lidl', name: 'Lidl', color: Color(0xFF0050AA)),
    Supermarket(id: 'alcampo', name: 'Alcampo', color: Color(0xFFE3000B)),
    Supermarket(id: 'dia', name: 'Dia', color: Color(0xFFE2001A)),
  ];

  // ─── PRODUCTOS (20) ──────────────────────────────────────────────────────────

  static const List<Product> products = [
    // Lácteos
    Product(id: 'p01', name: 'Leche semidesnatada 1L', brand: 'Hacendado', category: 'Lácteos', imageEmoji: '🥛'),
    Product(id: 'p02', name: 'Yogur natural x4', brand: 'Danone', category: 'Lácteos', imageEmoji: '🍶'),
    Product(id: 'p03', name: 'Queso manchego lonchas 200g', brand: 'García Baquero', category: 'Lácteos', imageEmoji: '🧀'),
    Product(id: 'p04', name: 'Mantequilla 250g', brand: 'Président', category: 'Lácteos', imageEmoji: '🧈'),
    Product(id: 'p05', name: 'Huevos medianos L x12', brand: 'El Pozo', category: 'Huevos', imageEmoji: '🥚'),

    // Panadería / Cereales
    Product(id: 'p06', name: 'Pan de molde integral', brand: 'Bimbo', category: 'Panadería', imageEmoji: '🍞'),
    Product(id: 'p07', name: 'Arroz largo 1kg', brand: 'La Fallera', category: 'Cereales', imageEmoji: '🍚'),
    Product(id: 'p08', name: 'Pasta espaguetis 500g', brand: 'Gallo', category: 'Cereales', imageEmoji: '🍝'),

    // Aceites / Conservas
    Product(id: 'p09', name: 'Aceite de oliva virgen 1L', brand: 'Carbonell', category: 'Aceites', imageEmoji: '🫒'),
    Product(id: 'p10', name: 'Tomate triturado 400g', brand: 'Apis', category: 'Conservas', imageEmoji: '🍅'),
    Product(id: 'p11', name: 'Atún en aceite x3', brand: 'Calvo', category: 'Conservas', imageEmoji: '🐟'),

    // Carnes / Embutidos
    Product(id: 'p12', name: 'Pechuga de pollo 1kg', brand: 'El Pozo', category: 'Carnes', imageEmoji: '🍗'),
    Product(id: 'p13', name: 'Jamón serrano lonchas 100g', brand: 'Navidul', category: 'Embutidos', imageEmoji: '🥩'),

    // Frutas / Verduras
    Product(id: 'p14', name: 'Tomates cherry 500g', brand: 'Mercadona', category: 'Verduras', imageEmoji: '🍒'),
    Product(id: 'p15', name: 'Plátanos de Canarias 1kg', brand: 'Plátano de Canarias', category: 'Frutas', imageEmoji: '🍌'),
    Product(id: 'p16', name: 'Manzanas Golden 1kg', brand: 'Frutas del campo', category: 'Frutas', imageEmoji: '🍎'),

    // Bebidas
    Product(id: 'p17', name: 'Zumo de naranja 100% 1L', brand: 'Don Simón', category: 'Bebidas', imageEmoji: '🍊'),
    Product(id: 'p18', name: 'Agua mineral 1.5L', brand: 'Bezoya', category: 'Bebidas', imageEmoji: '💧'),

    Product(id: 'p19', name: 'Café molido natural 250g', brand: 'Marcilla', category: 'Bebidas', imageEmoji: '☕'),
    Product(id: 'p20', name: 'Chocolate negro 70% 100g', brand: 'Valor', category: 'Dulces', imageEmoji: '🍫'),

    // Vegano
    Product(id: 'p21', name: 'Bebida de avena 1L', brand: 'Oatly', category: 'Vegano', imageEmoji: '🌾'),
    Product(id: 'p22', name: 'Bebida de almendras 1L', brand: 'Alpro', category: 'Vegano', imageEmoji: '🥛'),
    Product(id: 'p23', name: 'Tofu firme 400g', brand: 'Natumi', category: 'Vegano', imageEmoji: '🫙'),
    Product(id: 'p24', name: 'Hamburguesa vegetal x2', brand: 'Garden Gourmet', category: 'Vegano', imageEmoji: '🍔'),
    Product(id: 'p25', name: 'Bebida de coco 1L', brand: 'Alpro', category: 'Vegano', imageEmoji: '🥥'),
    Product(id: 'p26', name: 'Queso vegano en lonchas 150g', brand: 'Violife', category: 'Vegano', imageEmoji: '🧀'),
    Product(id: 'p27', name: 'Margarina vegana 250g', brand: 'Flora', category: 'Vegano', imageEmoji: '🧈'),
    Product(id: 'p28', name: 'Yogur de soja natural x4', brand: 'Alpro', category: 'Vegano', imageEmoji: '🍶'),
    Product(id: 'p29', name: 'Crema de cacahuete 350g', brand: 'Meridian', category: 'Vegano', imageEmoji: '🥜'),
    Product(id: 'p30', name: 'Hummus clásico 200g', brand: 'Florette', category: 'Vegano', imageEmoji: '🫘'),

    // Más Lácteos
    Product(id: 'p31', name: 'Nata para montar 200ml', brand: 'Président', category: 'Lácteos', imageEmoji: '🍦'),
    Product(id: 'p32', name: 'Queso fresco 250g', brand: 'Burgos', category: 'Lácteos', imageEmoji: '🧀'),

    // Más Panadería
    Product(id: 'p33', name: 'Tortitas de arroz x9', brand: 'Hacendado', category: 'Panadería', imageEmoji: '🫓'),
    Product(id: 'p34', name: 'Croissants x6', brand: 'La Bella Easo', category: 'Panadería', imageEmoji: '🥐'),
    Product(id: 'p35', name: 'Baguette precocida', brand: 'Hacendado', category: 'Panadería', imageEmoji: '🥖'),

    // Más Cereales
    Product(id: 'p36', name: 'Copos de avena 500g', brand: 'Quaker', category: 'Cereales', imageEmoji: '🌾'),
    Product(id: 'p37', name: 'Granola frutos secos 450g', brand: 'Jordans', category: 'Cereales', imageEmoji: '🥣'),
    Product(id: 'p38', name: 'Macarrones 500g', brand: 'Gallo', category: 'Cereales', imageEmoji: '🍝'),

    // Más Conservas
    Product(id: 'p39', name: 'Sardinas en aceite x3', brand: 'Rianxeira', category: 'Conservas', imageEmoji: '🐟'),
    Product(id: 'p40', name: 'Garbanzos cocidos 400g', brand: 'Luengo', category: 'Conservas', imageEmoji: '🫘'),
    Product(id: 'p41', name: 'Lentejas cocidas 400g', brand: 'Luengo', category: 'Conservas', imageEmoji: '🫘'),
    Product(id: 'p42', name: 'Maíz dulce 340g', brand: 'Green Giant', category: 'Conservas', imageEmoji: '🌽'),

    // Más Carnes / Embutidos
    Product(id: 'p43', name: 'Salchichas Frankfurt x6', brand: 'El Pozo', category: 'Embutidos', imageEmoji: '🌭'),
    Product(id: 'p44', name: 'Fiambre de pavo 100g', brand: 'Campofrío', category: 'Embutidos', imageEmoji: '🍖'),
    Product(id: 'p45', name: 'Carne picada mixta 500g', brand: 'El Pozo', category: 'Carnes', imageEmoji: '🥩'),

    // Más Frutas / Verduras
    Product(id: 'p46', name: 'Naranjas de mesa 2kg', brand: 'Frutas del campo', category: 'Frutas', imageEmoji: '🍊'),
    Product(id: 'p47', name: 'Lechuga iceberg', brand: 'Florette', category: 'Verduras', imageEmoji: '🥬'),
    Product(id: 'p48', name: 'Cebolla blanca 1kg', brand: 'Mercadona', category: 'Verduras', imageEmoji: '🧅'),
    Product(id: 'p49', name: 'Patatas 2kg', brand: 'Hacendado', category: 'Verduras', imageEmoji: '🥔'),
    Product(id: 'p50', name: 'Zanahorias 1kg', brand: 'Hacendado', category: 'Verduras', imageEmoji: '🥕'),
    Product(id: 'p51', name: 'Pimientos rojos x3', brand: 'Mercadona', category: 'Verduras', imageEmoji: '🫑'),
    Product(id: 'p52', name: 'Aguacates x2', brand: 'Hacendado', category: 'Frutas', imageEmoji: '🥑'),

    // Más Bebidas
    Product(id: 'p53', name: 'Cerveza sin alcohol x6', brand: 'Estrella Damm', category: 'Bebidas', imageEmoji: '🍺'),
    Product(id: 'p54', name: 'Refresco cola 2L', brand: 'Coca-Cola', category: 'Bebidas', imageEmoji: '🥤'),
    Product(id: 'p55', name: 'Zumo de manzana 1L', brand: 'Don Simón', category: 'Bebidas', imageEmoji: '🍎'),

    // Más Dulces / Snacks
    Product(id: 'p56', name: 'Patatas fritas onduladas 150g', brand: 'Lay\'s', category: 'Snacks', imageEmoji: '🥔'),
    Product(id: 'p57', name: 'Galletas María 800g', brand: 'Fontaneda', category: 'Dulces', imageEmoji: '🍪'),
    Product(id: 'p58', name: 'Mermelada de fresa 350g', brand: 'Helios', category: 'Dulces', imageEmoji: '🍓'),
    Product(id: 'p59', name: 'Miel pura 500g', brand: 'El Colmenar', category: 'Dulces', imageEmoji: '🍯'),
    Product(id: 'p60', name: 'Barritas de cereales x6', brand: 'Kellogs', category: 'Snacks', imageEmoji: '🌾'),
  ];

  // ─── PRECIOS (20 productos × 3 supermercados = 60 precios) ──────────────────
  // Nota: precios realistas del mercado español 2024-2025

  static const List<Price> prices = [
    // p01 - Leche semidesnatada 1L
    Price(productId: 'p01', supermarketId: 'mercadona', amount: 0.89),
    Price(productId: 'p01', supermarketId: 'carrefour', amount: 0.99),
    Price(productId: 'p01', supermarketId: 'lidl', amount: 0.79),

    // p02 - Yogur natural x4
    Price(productId: 'p02', supermarketId: 'mercadona', amount: 1.59),
    Price(productId: 'p02', supermarketId: 'carrefour', amount: 1.49),
    Price(productId: 'p02', supermarketId: 'lidl', amount: 1.29),

    // p03 - Queso manchego 200g
    Price(productId: 'p03', supermarketId: 'mercadona', amount: 3.49),
    Price(productId: 'p03', supermarketId: 'carrefour', amount: 3.89),
    Price(productId: 'p03', supermarketId: 'lidl', amount: 3.19),

    // p04 - Mantequilla 250g
    Price(productId: 'p04', supermarketId: 'mercadona', amount: 2.29),
    Price(productId: 'p04', supermarketId: 'carrefour', amount: 2.49),
    Price(productId: 'p04', supermarketId: 'lidl', amount: 1.99),

    // p05 - Huevos x12
    Price(productId: 'p05', supermarketId: 'mercadona', amount: 2.49),
    Price(productId: 'p05', supermarketId: 'carrefour', amount: 2.79),
    Price(productId: 'p05', supermarketId: 'lidl', amount: 2.19),

    // p06 - Pan de molde integral
    Price(productId: 'p06', supermarketId: 'mercadona', amount: 1.45),
    Price(productId: 'p06', supermarketId: 'carrefour', amount: 1.59),
    Price(productId: 'p06', supermarketId: 'lidl', amount: 1.25),

    // p07 - Arroz 1kg
    Price(productId: 'p07', supermarketId: 'mercadona', amount: 1.29),
    Price(productId: 'p07', supermarketId: 'carrefour', amount: 1.39),
    Price(productId: 'p07', supermarketId: 'lidl', amount: 1.09),

    // p08 - Pasta espaguetis 500g
    Price(productId: 'p08', supermarketId: 'mercadona', amount: 0.89),
    Price(productId: 'p08', supermarketId: 'carrefour', amount: 0.99),
    Price(productId: 'p08', supermarketId: 'lidl', amount: 0.75),

    // p09 - Aceite oliva 1L
    Price(productId: 'p09', supermarketId: 'mercadona', amount: 6.49),
    Price(productId: 'p09', supermarketId: 'carrefour', amount: 6.99),
    Price(productId: 'p09', supermarketId: 'lidl', amount: 5.99),

    // p10 - Tomate triturado 400g
    Price(productId: 'p10', supermarketId: 'mercadona', amount: 0.55),
    Price(productId: 'p10', supermarketId: 'carrefour', amount: 0.65),
    Price(productId: 'p10', supermarketId: 'lidl', amount: 0.49),

    // p11 - Atún x3
    Price(productId: 'p11', supermarketId: 'mercadona', amount: 2.49),
    Price(productId: 'p11', supermarketId: 'carrefour', amount: 2.89),
    Price(productId: 'p11', supermarketId: 'lidl', amount: 2.29),

    // p12 - Pechuga pollo 1kg
    Price(productId: 'p12', supermarketId: 'mercadona', amount: 5.49),
    Price(productId: 'p12', supermarketId: 'carrefour', amount: 5.99),
    Price(productId: 'p12', supermarketId: 'lidl', amount: 5.19),

    // p13 - Jamón serrano 100g
    Price(productId: 'p13', supermarketId: 'mercadona', amount: 2.99),
    Price(productId: 'p13', supermarketId: 'carrefour', amount: 3.29),
    Price(productId: 'p13', supermarketId: 'lidl', amount: 2.79),

    // p14 - Tomates cherry 500g
    Price(productId: 'p14', supermarketId: 'mercadona', amount: 1.99),
    Price(productId: 'p14', supermarketId: 'carrefour', amount: 2.29),
    Price(productId: 'p14', supermarketId: 'lidl', amount: 1.79),

    // p15 - Plátanos 1kg
    Price(productId: 'p15', supermarketId: 'mercadona', amount: 1.79),
    Price(productId: 'p15', supermarketId: 'carrefour', amount: 1.99),
    Price(productId: 'p15', supermarketId: 'lidl', amount: 1.59),

    // p16 - Manzanas 1kg
    Price(productId: 'p16', supermarketId: 'mercadona', amount: 1.49),
    Price(productId: 'p16', supermarketId: 'carrefour', amount: 1.79),
    Price(productId: 'p16', supermarketId: 'lidl', amount: 1.39),

    // p17 - Zumo naranja 1L
    Price(productId: 'p17', supermarketId: 'mercadona', amount: 1.89),
    Price(productId: 'p17', supermarketId: 'carrefour', amount: 2.19),
    Price(productId: 'p17', supermarketId: 'lidl', amount: 1.69),

    // p18 - Agua 1.5L
    Price(productId: 'p18', supermarketId: 'mercadona', amount: 0.45),
    Price(productId: 'p18', supermarketId: 'carrefour', amount: 0.49),
    Price(productId: 'p18', supermarketId: 'lidl', amount: 0.35),

    // p19 - Café molido 250g
    Price(productId: 'p19', supermarketId: 'mercadona', amount: 3.49),
    Price(productId: 'p19', supermarketId: 'carrefour', amount: 3.89),
    Price(productId: 'p19', supermarketId: 'lidl', amount: 2.99),

    // p20 - Chocolate negro 100g
    Price(productId: 'p20', supermarketId: 'mercadona', amount: 1.19),
    Price(productId: 'p20', supermarketId: 'carrefour', amount: 1.39),
    Price(productId: 'p20', supermarketId: 'lidl', amount: 0.99),
    Price(productId: 'p20', supermarketId: 'alcampo', amount: 1.09),
    Price(productId: 'p20', supermarketId: 'dia', amount: 1.25),

    // ── Alcampo y Dia para productos p01–p19 ────────────────────────────────
    Price(productId: 'p01', supermarketId: 'alcampo', amount: 0.95),
    Price(productId: 'p01', supermarketId: 'dia', amount: 0.85),

    Price(productId: 'p02', supermarketId: 'alcampo', amount: 1.55),
    Price(productId: 'p02', supermarketId: 'dia', amount: 1.39),

    Price(productId: 'p03', supermarketId: 'alcampo', amount: 3.69),
    Price(productId: 'p03', supermarketId: 'dia', amount: 3.29),

    Price(productId: 'p04', supermarketId: 'alcampo', amount: 2.39),
    Price(productId: 'p04', supermarketId: 'dia', amount: 2.19),

    Price(productId: 'p05', supermarketId: 'alcampo', amount: 2.59),
    Price(productId: 'p05', supermarketId: 'dia', amount: 2.35),

    Price(productId: 'p06', supermarketId: 'alcampo', amount: 1.49),
    Price(productId: 'p06', supermarketId: 'dia', amount: 1.35),

    Price(productId: 'p07', supermarketId: 'alcampo', amount: 1.19),
    Price(productId: 'p07', supermarketId: 'dia', amount: 1.05),

    Price(productId: 'p08', supermarketId: 'alcampo', amount: 0.95),
    Price(productId: 'p08', supermarketId: 'dia', amount: 0.85),

    Price(productId: 'p09', supermarketId: 'alcampo', amount: 6.79),
    Price(productId: 'p09', supermarketId: 'dia', amount: 6.29),

    Price(productId: 'p10', supermarketId: 'alcampo', amount: 0.59),
    Price(productId: 'p10', supermarketId: 'dia', amount: 0.52),

    Price(productId: 'p11', supermarketId: 'alcampo', amount: 2.69),
    Price(productId: 'p11', supermarketId: 'dia', amount: 2.45),

    Price(productId: 'p12', supermarketId: 'alcampo', amount: 5.79),
    Price(productId: 'p12', supermarketId: 'dia', amount: 5.39),

    Price(productId: 'p13', supermarketId: 'alcampo', amount: 3.19),
    Price(productId: 'p13', supermarketId: 'dia', amount: 2.89),

    Price(productId: 'p14', supermarketId: 'alcampo', amount: 2.09),
    Price(productId: 'p14', supermarketId: 'dia', amount: 1.89),

    Price(productId: 'p15', supermarketId: 'alcampo', amount: 1.89),
    Price(productId: 'p15', supermarketId: 'dia', amount: 1.69),

    Price(productId: 'p16', supermarketId: 'alcampo', amount: 1.59),
    Price(productId: 'p16', supermarketId: 'dia', amount: 1.45),

    Price(productId: 'p17', supermarketId: 'alcampo', amount: 1.99),
    Price(productId: 'p17', supermarketId: 'dia', amount: 1.79),

    Price(productId: 'p18', supermarketId: 'alcampo', amount: 0.45),
    Price(productId: 'p18', supermarketId: 'dia', amount: 0.39),

    Price(productId: 'p19', supermarketId: 'alcampo', amount: 3.69),
    Price(productId: 'p19', supermarketId: 'dia', amount: 3.39),

    // ── Nuevos productos p21–p60 (5 supermercados) ──────────────────────────

    // p21 - Bebida de avena 1L
    Price(productId: 'p21', supermarketId: 'mercadona', amount: 1.49),
    Price(productId: 'p21', supermarketId: 'carrefour', amount: 1.89),
    Price(productId: 'p21', supermarketId: 'lidl', amount: 1.29),
    Price(productId: 'p21', supermarketId: 'alcampo', amount: 1.69),
    Price(productId: 'p21', supermarketId: 'dia', amount: 1.55),

    // p22 - Bebida de almendras 1L
    Price(productId: 'p22', supermarketId: 'mercadona', amount: 1.59),
    Price(productId: 'p22', supermarketId: 'carrefour', amount: 1.99),
    Price(productId: 'p22', supermarketId: 'lidl', amount: 1.39),
    Price(productId: 'p22', supermarketId: 'alcampo', amount: 1.79),
    Price(productId: 'p22', supermarketId: 'dia', amount: 1.65),

    // p23 - Tofu firme 400g
    Price(productId: 'p23', supermarketId: 'mercadona', amount: 2.19),
    Price(productId: 'p23', supermarketId: 'carrefour', amount: 2.49),
    Price(productId: 'p23', supermarketId: 'lidl', amount: 1.99),
    Price(productId: 'p23', supermarketId: 'alcampo', amount: 2.29),
    Price(productId: 'p23', supermarketId: 'dia', amount: 2.09),

    // p24 - Hamburguesa vegetal x2
    Price(productId: 'p24', supermarketId: 'mercadona', amount: 3.49),
    Price(productId: 'p24', supermarketId: 'carrefour', amount: 3.99),
    Price(productId: 'p24', supermarketId: 'lidl', amount: 2.99),
    Price(productId: 'p24', supermarketId: 'alcampo', amount: 3.69),
    Price(productId: 'p24', supermarketId: 'dia', amount: 3.29),

    // p25 - Bebida de coco 1L
    Price(productId: 'p25', supermarketId: 'mercadona', amount: 1.69),
    Price(productId: 'p25', supermarketId: 'carrefour', amount: 1.99),
    Price(productId: 'p25', supermarketId: 'lidl', amount: 1.49),
    Price(productId: 'p25', supermarketId: 'alcampo', amount: 1.79),
    Price(productId: 'p25', supermarketId: 'dia', amount: 1.59),

    // p26 - Queso vegano lonchas 150g
    Price(productId: 'p26', supermarketId: 'mercadona', amount: 2.99),
    Price(productId: 'p26', supermarketId: 'carrefour', amount: 3.49),
    Price(productId: 'p26', supermarketId: 'lidl', amount: 2.79),
    Price(productId: 'p26', supermarketId: 'alcampo', amount: 3.19),
    Price(productId: 'p26', supermarketId: 'dia', amount: 2.89),

    // p27 - Margarina vegana 250g
    Price(productId: 'p27', supermarketId: 'mercadona', amount: 1.89),
    Price(productId: 'p27', supermarketId: 'carrefour', amount: 2.19),
    Price(productId: 'p27', supermarketId: 'lidl', amount: 1.69),
    Price(productId: 'p27', supermarketId: 'alcampo', amount: 1.99),
    Price(productId: 'p27', supermarketId: 'dia', amount: 1.79),

    // p28 - Yogur de soja x4
    Price(productId: 'p28', supermarketId: 'mercadona', amount: 1.99),
    Price(productId: 'p28', supermarketId: 'carrefour', amount: 2.29),
    Price(productId: 'p28', supermarketId: 'lidl', amount: 1.79),
    Price(productId: 'p28', supermarketId: 'alcampo', amount: 2.09),
    Price(productId: 'p28', supermarketId: 'dia', amount: 1.89),

    // p29 - Crema de cacahuete 350g
    Price(productId: 'p29', supermarketId: 'mercadona', amount: 2.49),
    Price(productId: 'p29', supermarketId: 'carrefour', amount: 2.99),
    Price(productId: 'p29', supermarketId: 'lidl', amount: 2.19),
    Price(productId: 'p29', supermarketId: 'alcampo', amount: 2.69),
    Price(productId: 'p29', supermarketId: 'dia', amount: 2.39),

    // p30 - Hummus clásico 200g
    Price(productId: 'p30', supermarketId: 'mercadona', amount: 1.79),
    Price(productId: 'p30', supermarketId: 'carrefour', amount: 2.09),
    Price(productId: 'p30', supermarketId: 'lidl', amount: 1.59),
    Price(productId: 'p30', supermarketId: 'alcampo', amount: 1.89),
    Price(productId: 'p30', supermarketId: 'dia', amount: 1.69),

    // p31 - Nata para montar 200ml
    Price(productId: 'p31', supermarketId: 'mercadona', amount: 1.29),
    Price(productId: 'p31', supermarketId: 'carrefour', amount: 1.49),
    Price(productId: 'p31', supermarketId: 'lidl', amount: 1.09),
    Price(productId: 'p31', supermarketId: 'alcampo', amount: 1.39),
    Price(productId: 'p31', supermarketId: 'dia', amount: 1.19),

    // p32 - Queso fresco 250g
    Price(productId: 'p32', supermarketId: 'mercadona', amount: 1.59),
    Price(productId: 'p32', supermarketId: 'carrefour', amount: 1.79),
    Price(productId: 'p32', supermarketId: 'lidl', amount: 1.39),
    Price(productId: 'p32', supermarketId: 'alcampo', amount: 1.69),
    Price(productId: 'p32', supermarketId: 'dia', amount: 1.49),

    // p33 - Tortitas de arroz x9
    Price(productId: 'p33', supermarketId: 'mercadona', amount: 0.89),
    Price(productId: 'p33', supermarketId: 'carrefour', amount: 1.09),
    Price(productId: 'p33', supermarketId: 'lidl', amount: 0.75),
    Price(productId: 'p33', supermarketId: 'alcampo', amount: 0.99),
    Price(productId: 'p33', supermarketId: 'dia', amount: 0.85),

    // p34 - Croissants x6
    Price(productId: 'p34', supermarketId: 'mercadona', amount: 1.99),
    Price(productId: 'p34', supermarketId: 'carrefour', amount: 2.29),
    Price(productId: 'p34', supermarketId: 'lidl', amount: 1.79),
    Price(productId: 'p34', supermarketId: 'alcampo', amount: 2.09),
    Price(productId: 'p34', supermarketId: 'dia', amount: 1.89),

    // p35 - Baguette precocida
    Price(productId: 'p35', supermarketId: 'mercadona', amount: 0.69),
    Price(productId: 'p35', supermarketId: 'carrefour', amount: 0.85),
    Price(productId: 'p35', supermarketId: 'lidl', amount: 0.59),
    Price(productId: 'p35', supermarketId: 'alcampo', amount: 0.79),
    Price(productId: 'p35', supermarketId: 'dia', amount: 0.72),

    // p36 - Copos de avena 500g
    Price(productId: 'p36', supermarketId: 'mercadona', amount: 0.99),
    Price(productId: 'p36', supermarketId: 'carrefour', amount: 1.19),
    Price(productId: 'p36', supermarketId: 'lidl', amount: 0.85),
    Price(productId: 'p36', supermarketId: 'alcampo', amount: 1.09),
    Price(productId: 'p36', supermarketId: 'dia', amount: 0.95),

    // p37 - Granola frutos secos 450g
    Price(productId: 'p37', supermarketId: 'mercadona', amount: 2.99),
    Price(productId: 'p37', supermarketId: 'carrefour', amount: 3.49),
    Price(productId: 'p37', supermarketId: 'lidl', amount: 2.69),
    Price(productId: 'p37', supermarketId: 'alcampo', amount: 3.19),
    Price(productId: 'p37', supermarketId: 'dia', amount: 2.89),

    // p38 - Macarrones 500g
    Price(productId: 'p38', supermarketId: 'mercadona', amount: 0.79),
    Price(productId: 'p38', supermarketId: 'carrefour', amount: 0.95),
    Price(productId: 'p38', supermarketId: 'lidl', amount: 0.69),
    Price(productId: 'p38', supermarketId: 'alcampo', amount: 0.89),
    Price(productId: 'p38', supermarketId: 'dia', amount: 0.75),

    // p39 - Sardinas en aceite x3
    Price(productId: 'p39', supermarketId: 'mercadona', amount: 2.29),
    Price(productId: 'p39', supermarketId: 'carrefour', amount: 2.59),
    Price(productId: 'p39', supermarketId: 'lidl', amount: 1.99),
    Price(productId: 'p39', supermarketId: 'alcampo', amount: 2.45),
    Price(productId: 'p39', supermarketId: 'dia', amount: 2.19),

    // p40 - Garbanzos cocidos 400g
    Price(productId: 'p40', supermarketId: 'mercadona', amount: 0.79),
    Price(productId: 'p40', supermarketId: 'carrefour', amount: 0.95),
    Price(productId: 'p40', supermarketId: 'lidl', amount: 0.69),
    Price(productId: 'p40', supermarketId: 'alcampo', amount: 0.85),
    Price(productId: 'p40', supermarketId: 'dia', amount: 0.75),

    // p41 - Lentejas cocidas 400g
    Price(productId: 'p41', supermarketId: 'mercadona', amount: 0.75),
    Price(productId: 'p41', supermarketId: 'carrefour', amount: 0.89),
    Price(productId: 'p41', supermarketId: 'lidl', amount: 0.65),
    Price(productId: 'p41', supermarketId: 'alcampo', amount: 0.82),
    Price(productId: 'p41', supermarketId: 'dia', amount: 0.72),

    // p42 - Maíz dulce 340g
    Price(productId: 'p42', supermarketId: 'mercadona', amount: 0.89),
    Price(productId: 'p42', supermarketId: 'carrefour', amount: 1.09),
    Price(productId: 'p42', supermarketId: 'lidl', amount: 0.79),
    Price(productId: 'p42', supermarketId: 'alcampo', amount: 0.99),
    Price(productId: 'p42', supermarketId: 'dia', amount: 0.85),

    // p43 - Salchichas Frankfurt x6
    Price(productId: 'p43', supermarketId: 'mercadona', amount: 1.59),
    Price(productId: 'p43', supermarketId: 'carrefour', amount: 1.89),
    Price(productId: 'p43', supermarketId: 'lidl', amount: 1.39),
    Price(productId: 'p43', supermarketId: 'alcampo', amount: 1.69),
    Price(productId: 'p43', supermarketId: 'dia', amount: 1.49),

    // p44 - Fiambre de pavo 100g
    Price(productId: 'p44', supermarketId: 'mercadona', amount: 1.49),
    Price(productId: 'p44', supermarketId: 'carrefour', amount: 1.69),
    Price(productId: 'p44', supermarketId: 'lidl', amount: 1.29),
    Price(productId: 'p44', supermarketId: 'alcampo', amount: 1.59),
    Price(productId: 'p44', supermarketId: 'dia', amount: 1.39),

    // p45 - Carne picada mixta 500g
    Price(productId: 'p45', supermarketId: 'mercadona', amount: 3.99),
    Price(productId: 'p45', supermarketId: 'carrefour', amount: 4.49),
    Price(productId: 'p45', supermarketId: 'lidl', amount: 3.69),
    Price(productId: 'p45', supermarketId: 'alcampo', amount: 4.19),
    Price(productId: 'p45', supermarketId: 'dia', amount: 3.89),

    // p46 - Naranjas 2kg
    Price(productId: 'p46', supermarketId: 'mercadona', amount: 2.49),
    Price(productId: 'p46', supermarketId: 'carrefour', amount: 2.79),
    Price(productId: 'p46', supermarketId: 'lidl', amount: 2.19),
    Price(productId: 'p46', supermarketId: 'alcampo', amount: 2.59),
    Price(productId: 'p46', supermarketId: 'dia', amount: 2.39),

    // p47 - Lechuga iceberg
    Price(productId: 'p47', supermarketId: 'mercadona', amount: 0.99),
    Price(productId: 'p47', supermarketId: 'carrefour', amount: 1.19),
    Price(productId: 'p47', supermarketId: 'lidl', amount: 0.85),
    Price(productId: 'p47', supermarketId: 'alcampo', amount: 1.09),
    Price(productId: 'p47', supermarketId: 'dia', amount: 0.95),

    // p48 - Cebolla 1kg
    Price(productId: 'p48', supermarketId: 'mercadona', amount: 0.89),
    Price(productId: 'p48', supermarketId: 'carrefour', amount: 1.05),
    Price(productId: 'p48', supermarketId: 'lidl', amount: 0.75),
    Price(productId: 'p48', supermarketId: 'alcampo', amount: 0.95),
    Price(productId: 'p48', supermarketId: 'dia', amount: 0.82),

    // p49 - Patatas 2kg
    Price(productId: 'p49', supermarketId: 'mercadona', amount: 1.89),
    Price(productId: 'p49', supermarketId: 'carrefour', amount: 2.19),
    Price(productId: 'p49', supermarketId: 'lidl', amount: 1.69),
    Price(productId: 'p49', supermarketId: 'alcampo', amount: 1.99),
    Price(productId: 'p49', supermarketId: 'dia', amount: 1.79),

    // p50 - Zanahorias 1kg
    Price(productId: 'p50', supermarketId: 'mercadona', amount: 0.99),
    Price(productId: 'p50', supermarketId: 'carrefour', amount: 1.19),
    Price(productId: 'p50', supermarketId: 'lidl', amount: 0.85),
    Price(productId: 'p50', supermarketId: 'alcampo', amount: 1.09),
    Price(productId: 'p50', supermarketId: 'dia', amount: 0.92),

    // p51 - Pimientos rojos x3
    Price(productId: 'p51', supermarketId: 'mercadona', amount: 1.59),
    Price(productId: 'p51', supermarketId: 'carrefour', amount: 1.89),
    Price(productId: 'p51', supermarketId: 'lidl', amount: 1.39),
    Price(productId: 'p51', supermarketId: 'alcampo', amount: 1.69),
    Price(productId: 'p51', supermarketId: 'dia', amount: 1.49),

    // p52 - Aguacates x2
    Price(productId: 'p52', supermarketId: 'mercadona', amount: 1.79),
    Price(productId: 'p52', supermarketId: 'carrefour', amount: 2.09),
    Price(productId: 'p52', supermarketId: 'lidl', amount: 1.59),
    Price(productId: 'p52', supermarketId: 'alcampo', amount: 1.89),
    Price(productId: 'p52', supermarketId: 'dia', amount: 1.69),

    // p53 - Cerveza sin alcohol x6
    Price(productId: 'p53', supermarketId: 'mercadona', amount: 3.49),
    Price(productId: 'p53', supermarketId: 'carrefour', amount: 3.99),
    Price(productId: 'p53', supermarketId: 'lidl', amount: 2.99),
    Price(productId: 'p53', supermarketId: 'alcampo', amount: 3.69),
    Price(productId: 'p53', supermarketId: 'dia', amount: 3.29),

    // p54 - Refresco cola 2L
    Price(productId: 'p54', supermarketId: 'mercadona', amount: 1.99),
    Price(productId: 'p54', supermarketId: 'carrefour', amount: 2.29),
    Price(productId: 'p54', supermarketId: 'lidl', amount: 1.49),
    Price(productId: 'p54', supermarketId: 'alcampo', amount: 2.09),
    Price(productId: 'p54', supermarketId: 'dia', amount: 1.89),

    // p55 - Zumo de manzana 1L
    Price(productId: 'p55', supermarketId: 'mercadona', amount: 1.29),
    Price(productId: 'p55', supermarketId: 'carrefour', amount: 1.59),
    Price(productId: 'p55', supermarketId: 'lidl', amount: 1.09),
    Price(productId: 'p55', supermarketId: 'alcampo', amount: 1.39),
    Price(productId: 'p55', supermarketId: 'dia', amount: 1.19),

    // p56 - Patatas fritas 150g
    Price(productId: 'p56', supermarketId: 'mercadona', amount: 1.49),
    Price(productId: 'p56', supermarketId: 'carrefour', amount: 1.79),
    Price(productId: 'p56', supermarketId: 'lidl', amount: 1.19),
    Price(productId: 'p56', supermarketId: 'alcampo', amount: 1.59),
    Price(productId: 'p56', supermarketId: 'dia', amount: 1.39),

    // p57 - Galletas María 800g
    Price(productId: 'p57', supermarketId: 'mercadona', amount: 1.89),
    Price(productId: 'p57', supermarketId: 'carrefour', amount: 2.19),
    Price(productId: 'p57', supermarketId: 'lidl', amount: 1.59),
    Price(productId: 'p57', supermarketId: 'alcampo', amount: 1.99),
    Price(productId: 'p57', supermarketId: 'dia', amount: 1.79),

    // p58 - Mermelada de fresa 350g
    Price(productId: 'p58', supermarketId: 'mercadona', amount: 1.49),
    Price(productId: 'p58', supermarketId: 'carrefour', amount: 1.79),
    Price(productId: 'p58', supermarketId: 'lidl', amount: 1.29),
    Price(productId: 'p58', supermarketId: 'alcampo', amount: 1.59),
    Price(productId: 'p58', supermarketId: 'dia', amount: 1.39),

    // p59 - Miel pura 500g
    Price(productId: 'p59', supermarketId: 'mercadona', amount: 3.99),
    Price(productId: 'p59', supermarketId: 'carrefour', amount: 4.49),
    Price(productId: 'p59', supermarketId: 'lidl', amount: 3.49),
    Price(productId: 'p59', supermarketId: 'alcampo', amount: 4.19),
    Price(productId: 'p59', supermarketId: 'dia', amount: 3.79),

    // p60 - Barritas de cereales x6
    Price(productId: 'p60', supermarketId: 'mercadona', amount: 2.29),
    Price(productId: 'p60', supermarketId: 'carrefour', amount: 2.69),
    Price(productId: 'p60', supermarketId: 'lidl', amount: 1.99),
    Price(productId: 'p60', supermarketId: 'alcampo', amount: 2.49),
    Price(productId: 'p60', supermarketId: 'dia', amount: 2.19),
  ];

  static const List<String> categories = [
    'Todos',
    'Vegano',
    'Lácteos',
    'Huevos',
    'Panadería',
    'Cereales',
    'Aceites',
    'Conservas',
    'Carnes',
    'Embutidos',
    'Frutas',
    'Verduras',
    'Bebidas',
    'Dulces',
    'Snacks',
  ];

  // Productos destacados en home (los más buscados)
  static const List<String> featuredProductIds = [
    'p01', 'p05', 'p07', 'p09', 'p12', 'p15',
  ];
}
