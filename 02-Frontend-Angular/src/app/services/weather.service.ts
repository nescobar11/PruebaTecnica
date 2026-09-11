import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { forkJoin, Observable, map } from 'rxjs';
import { City, WeatherResponse, WeatherRow } from '../models/weather.models';

@Injectable({ providedIn: 'root' })
export class WeatherService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = 'https://api.open-meteo.com/v1/forecast';

  private readonly cities: City[] = [
    { name: 'Bogotá', latitude: 4.7110, longitude: -74.0721, country: 'Colombia' },
    { name: 'Medellín', latitude: 6.2442, longitude: -75.5812, country: 'Colombia' },
    { name: 'Cali', latitude: 3.4516, longitude: -76.5320, country: 'Colombia' },
    { name: 'Cartagena', latitude: 10.3910, longitude: -75.4794, country: 'Colombia' },
    { name: 'Barranquilla', latitude: 10.9685, longitude: -74.7813, country: 'Colombia' },
    { name: 'Manizales', latitude: 5.0703, longitude: -75.5138, country: 'Colombia' },
    { name: 'Bucaramanga', latitude: 7.1193, longitude: -73.1227, country: 'Colombia' },
    { name: 'Pereira', latitude: 4.8143, longitude: -75.6946, country: 'Colombia' }
  ];

  getWeatherForCities(): Observable<WeatherRow[]> {
    return forkJoin(
      this.cities.map(city => {
        const params = new HttpParams()
          .set('latitude', city.latitude)
          .set('longitude', city.longitude)
          .set('current', 'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m')
          .set('timezone', 'auto');

        return this.http.get<WeatherResponse>(this.baseUrl, { params });
      })
    ).pipe(
      map(responses => responses.map((response, index) =>
        this.mapResponse(this.cities[index], response)
      ))
    );
  }

  mapResponse(city: City, response: WeatherResponse): WeatherRow {
    const current = response.current;
    return {
      city: city.name,
      country: city.country,
      temperature: current.temperature_2m,
      apparentTemperature: current.apparent_temperature,
      humidity: current.relative_humidity_2m,
      precipitation: current.precipitation,
      windSpeed: current.wind_speed_10m,
      condition: this.weatherDescription(current.weather_code),
      icon: this.weatherIcon(current.weather_code)
    };
  }

  getCities(): City[] {
    return this.cities;
  }

  private weatherDescription(code: number): string {
    if (code === 0) return 'Despejado';
    if ([1, 2, 3].includes(code)) return 'Parcialmente nublado';
    if ([45, 48].includes(code)) return 'Niebla';
    if ([51, 53, 55, 56, 57].includes(code)) return 'Llovizna';
    if ([61, 63, 65, 66, 67, 80, 81, 82].includes(code)) return 'Lluvia';
    if ([71, 73, 75, 77, 85, 86].includes(code)) return 'Nieve';
    if ([95, 96, 99].includes(code)) return 'Tormenta';
    return 'Condición desconocida';
  }

  private weatherIcon(code: number): string {
    if (code === 0) return '☀️';
    if ([1, 2, 3].includes(code)) return '⛅';
    if ([45, 48].includes(code)) return '🌫️';
    if ([51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82].includes(code)) return '🌧️';
    if ([71, 73, 75, 77, 85, 86].includes(code)) return '❄️';
    if ([95, 96, 99].includes(code)) return '⛈️';
    return '🌡️';
  }
}
