import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/network/repository.dart';

part 'countries_event.dart';
part 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  CountriesBloc() : super(CountriesLoading()) {
    on<GetCountryEvent>(_getCountries);
    on<GetRegionEvent>(_getRegions);
    on<GetTownsEvent>(_getTowns);
  }

  List<Countries> country = [];
  List<Regions> region = [];
  List<Town> town = [];

  void _getCountries(
      GetCountryEvent event, Emitter<CountriesState> emit) async {
    emit(CountriesLoading());
    country = await Repository().countries();
  }

  void _getRegions(GetRegionEvent event, Emitter<CountriesState> emit) async {
    List<Regions> regionTemp = [];
    for (var element in event.countries) {
      regionTemp.addAll(await Repository().regions(element));
    }
    region.clear();
    region.addAll(regionTemp);
    emit(CountriesUpdateState());
    add(GetTownsEvent(region));
  }

  void _getTowns(GetTownsEvent event, Emitter<CountriesState> emit) async {
    List<Town> townTemp = [];
    town.clear();
    emit(CountriesUpdateState());
    for (var element in event.regions) {
      townTemp.addAll(await Repository().towns(element));
    }
    town.addAll(townTemp);
    emit(CountriesUpdateState());
  }
}
