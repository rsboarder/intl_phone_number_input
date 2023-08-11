import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';

/// Creates a list of Countries with a search textfield.
class CountrySearchListWidget extends StatefulWidget {
  final List<Country> countries;
  final InputDecoration? searchBoxDecoration;
  final String? locale;
  final String countryListTitle;
  final ScrollController? scrollController;
  final bool autoFocus;
  final bool? showFlags;
  final bool? useEmoji;

  CountrySearchListWidget(
    this.countries,
    this.locale, {
    this.searchBoxDecoration,
    this.scrollController,
    this.showFlags,
    this.useEmoji,
    this.autoFocus = false,
    required this.countryListTitle,
  });

  @override
  _CountrySearchListWidgetState createState() =>
      _CountrySearchListWidgetState();
}

class _CountrySearchListWidgetState extends State<CountrySearchListWidget> {
  late TextEditingController _searchController = TextEditingController();
  late List<Country> filteredCountries;

  @override
  void initState() {
    final String value = _searchController.text.trim();
    filteredCountries = Utils.filterCountries(
      countries: widget.countries,
      locale: widget.locale,
      value: value,
    );
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Returns [InputDecoration] of the search box
  InputDecoration getSearchBoxDecoration() {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: Color.fromRGBO(243, 246, 249, 1),
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: Color.fromRGBO(243, 246, 249, 1),
        ),
      ),
      contentPadding: const EdgeInsets.only(
        top: 9,
        right: 8,
        bottom: 8,
        left: 8,
      ),
      filled: true,
      fillColor: Color.fromRGBO(243, 246, 249, 1),
      isDense: true,
      isCollapsed: true,
      labelText: '',
      hintText: 'Search',
      hintStyle: GoogleFonts.inter(
        color: Color.fromRGBO(148, 160, 180, 1),
        fontSize: 16,
      ),
      prefixIcon: Container(
        padding: const EdgeInsets.only(
          right: 6,
          left: 8,
        ),
        child: SvgPicture.asset(
          'assets/icons/magnify.svg',
          package: 'intl_phone_number_input',
          width: 16,
          height: 16,
        ),
      ),
      prefixIconConstraints: BoxConstraints(
        maxWidth: 42,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 28, left: 16, bottom: 8),
            child: Text(
              widget.countryListTitle,
              style: GoogleFonts.montserrat(
                color: Color.fromRGBO(43, 52, 80, 1),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: getSearchBoxDecoration(),
                    style: GoogleFonts.inter(
                      color: Color.fromRGBO(43, 52, 80, 1),
                      fontSize: 16,
                    ),
                    controller: _searchController,
                    onChanged: (value) {
                      final String value = _searchController.text.trim();
                      return setState(
                        () => filteredCountries = Utils.filterCountries(
                          countries: widget.countries,
                          locale: widget.locale,
                          value: value,
                        ),
                      );
                    },
                  ),
                ),
                _searchController.text.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(left: 14),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              color: Color.fromRGBO(43, 52, 80, 1),
                              fontSize: 17,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              controller: widget.scrollController,
              shrinkWrap: true,
              itemCount: filteredCountries.length,
              itemBuilder: (BuildContext context, int index) {
                Country country = filteredCountries[index];

                return DirectionalCountryListTile(
                  country: country,
                  locale: widget.locale,
                  showFlags: widget.showFlags!,
                  useEmoji: widget.useEmoji!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class DirectionalCountryListTile extends StatelessWidget {
  final Country country;
  final String? locale;
  final bool showFlags;
  final bool useEmoji;

  const DirectionalCountryListTile({
    Key? key,
    required this.country,
    required this.locale,
    required this.showFlags,
    required this.useEmoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(country),
      child: Container(
        key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(243, 246, 249, 1),
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 56,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Flag(country: country, useEmoji: useEmoji),
            SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Text(
                '${Utils.getCountryName(country, locale)}',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Color.fromRGBO(43, 52, 80, 1),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 16),
            Text(
              '${country.dialCode ?? ''}',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Color.fromRGBO(148, 160, 180, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? useEmoji;

  const _Flag({Key? key, this.country, this.useEmoji}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      child: Image.asset(
        country!.flagUri,
        package: 'intl_phone_number_input',
      ),
    );
  }
}
