import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'item_screen.dart';
import '../data/data_provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchCtl = TextEditingController();
  String _query = '';
  Map<String, List<_SubCat>> _sections = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final raw = await DataProvider().getCategories();
    final mapped = <String, List<_SubCat>>{};
    raw.forEach((key, list) {
      mapped[key] = list
          .map((e) => _SubCat(parent: e['parent']!, title: e['title']!, filter: e['filter']!, image: e['image']!))
          .toList();
    });
    if (!mounted) return;
    setState(() => _sections = mapped);
  }

  Map<String, List<_SubCat>> get _filteredSections {
    if (_query.trim().isEmpty) return _sections;
    final q = _query.toLowerCase();
    final Map<String, List<_SubCat>> out = {};
    _sections.forEach((section, subs) {
      final matched = subs.where((s) => s.title.toLowerCase().contains(q)).toList();
      if (matched.isNotEmpty) out[section] = matched;
    });
    return out;
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                color: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset('assets/images/logo1.png', fit: BoxFit.contain),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchCtl,
                                onChanged: (v) => setState(() => _query = v),
                                decoration: InputDecoration(
                                  hintText: 'Search categories',
                                  hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            if (_query.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _searchCtl.clear();
                                  setState(() => _query = '');
                                },
                                child: const Icon(Icons.clear, color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("Browse Categories", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
              ),
              const SizedBox(height: 10),

              ..._filteredSections.entries.map((entry) => _buildSection(entry.key, entry.value)).toList(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<_SubCat> subs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: subs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final s = subs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FreshMarketScreen(
                        initialFilter: s.filter,
                        initialIsCategory: false,
                        initialCategoryTitle: s.parent,
                      ),
                    ),
                  );
                },
                child: _buildCategoryCard(s.image, s.title),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String imagePath, String title) {
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200, blurRadius: 5, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 40, width: 40, fit: BoxFit.contain),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 10),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SubCat {
  final String parent;
  final String title;
  final String filter;
  final String image;
  _SubCat({required this.parent, required this.title, required this.filter, required this.image});
}
