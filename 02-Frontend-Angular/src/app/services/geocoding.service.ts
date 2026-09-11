import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, map } from 'rxjs';
import { City, GeocodingResponse } from '../models/weather.models';

@Injectable({ providedIn: 'root' })
export class GeocodingService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  searchCity(name: string): Observable<City | null> {
    const params = new HttpParams()
      .set('name', name)
      .set('count', '1')
      .set('language', 'es')
      .set('format', 'json');

    return this.http.get<GeocodingResponse>(this.baseUrl, { params }).pipe(
      map(response => {
        const result = response.results?.[0];
        return result
          ? { name: result.name, latitude: result.latitude, longitude: result.longitude, country: result.country }
          : null;
      })
    );
  }
}
