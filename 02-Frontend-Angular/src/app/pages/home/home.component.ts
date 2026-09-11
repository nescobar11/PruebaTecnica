import { CommonModule } from '@angular/common';
import { Component, OnInit, inject } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { MatTableModule } from '@angular/material/table';
import { MatTooltipModule } from '@angular/material/tooltip';
import { finalize } from 'rxjs';
import { City, WeatherResponse, WeatherRow } from '../../models/weather.models';
import { GeocodingService } from '../../services/geocoding.service';
import { WeatherService } from '../../services/weather.service';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [
    CommonModule,
    MatButtonModule,
    MatIconModule,
    MatInputModule,
    MatPaginatorModule,
    MatProgressSpinnerModule,
    MatSnackBarModule,
    MatTableModule,
    MatTooltipModule
  ],
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent implements OnInit {
  private readonly weatherService = inject(WeatherService);
  private readonly geocodingService = inject(GeocodingService);
  private readonly snackBar = inject(MatSnackBar);

  readonly columns = ['city', 'temperature', 'condition', 'humidity', 'wind', 'precipitation'];
  rows: WeatherRow[] = [];
  filteredRows: WeatherRow[] = [];
  displayedRows: WeatherRow[] = [];
  search = '';
  pageSize = 5;
  pageIndex = 0;
  loading = false;
  error = '';

  ngOnInit(): void {
    this.loadWeather();
  }

  loadWeather(): void {
    this.loading = true;
    this.error = '';

    this.weatherService.getWeatherForCities().pipe(
      finalize(() => this.loading = false)
    ).subscribe({
      next: rows => {
        this.rows = rows;
        this.applyFilter();
      },
      error: () => {
        this.error = 'No fue posible consultar el servicio meteorológico. Intenta nuevamente.';
        this.snackBar.open(this.error, 'Cerrar', { duration: 5000 });
      }
    });
  }

  onSearch(event: Event): void {
    this.search = (event.target as HTMLInputElement).value.toLowerCase().trim();
    this.pageIndex = 0;
    this.applyFilter();
  }

  onPage(event: PageEvent): void {
    this.pageIndex = event.pageIndex;
    this.pageSize = event.pageSize;
    this.updatePage();
  }

  private applyFilter(): void {
    this.filteredRows = this.rows.filter(row =>
      row.city.toLowerCase().includes(this.search)
    );
    this.updatePage();
  }

  private updatePage(): void {
    const start = this.pageIndex * this.pageSize;
    this.displayedRows = this.filteredRows.slice(start, start + this.pageSize);
  }

  trackByCity(_: number, row: WeatherRow): string {
    return row.city;
  }
}
