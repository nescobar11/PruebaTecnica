import { ComponentFixture, TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting } from '@angular/common/http/testing';
import { HomeComponent } from './home.component';
import { WeatherService } from '../../services/weather.service';

describe('HomeComponent', () => {
  let component: HomeComponent;
  let fixture: ComponentFixture<HomeComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [HomeComponent],
      providers: [
        WeatherService,
        provideHttpClient(),
        provideHttpClientTesting()
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(HomeComponent);
    component = fixture.componentInstance;
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should filter cities by name', () => {
    component.rows = [
      {
        city: 'Bogotá', country: 'Colombia', temperature: 18,
        apparentTemperature: 18, humidity: 70, precipitation: 0,
        windSpeed: 10, condition: 'Despejado', icon: '☀️'
      },
      {
        city: 'Cali', country: 'Colombia', temperature: 25,
        apparentTemperature: 25, humidity: 60, precipitation: 0,
        windSpeed: 8, condition: 'Despejado', icon: '☀️'
      }
    ];

    component.onSearch({ target: { value: 'bog' } } as unknown as Event);
    expect(component.filteredRows.length).toBe(1);
    expect(component.filteredRows[0].city).toBe('Bogotá');
  });
});
