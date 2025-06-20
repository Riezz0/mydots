#!/usr/bin/env python3
import requests
import json
from pathlib import Path
from datetime import datetime, timedelta
import sys

# Configuration - Paths adjusted for ~/.config/scripts/
SCRIPT_DIR = Path.home() / ".config" / "scripts"
CACHE_DIR = SCRIPT_DIR / "weather_cache"
CACHE_FILE = CACHE_DIR / "weather.json"
CONFIG_FILE = SCRIPT_DIR / "weather_config.json"

# Default configuration with larger icon settings
DEFAULT_CONFIG = {
    "provider": "openweathermap",
    "location": "London",
    "api_key": "your_api_key_here",
    "units": "metric",
    "update_interval": 3600,
    "icon_size": "x-large",  # Can be: small, medium, large, x-large, xx-large
    "text_size": "large",
    "format": "<span size='{icon_size}' rise='5000'>{icon}</span> <span size='{text_size}'>{temp}°{unit}</span>",
    "tooltip_format": "{conditions}\nHumidity: {humidity}%\nWind: {wind} {wind_unit}\nUpdated: {updated}",
    "icons": {
        "01d": "<span font='20px'></span>",  # Sunny (day)
        "01n": "<span font='20px'></span>",  # Clear (night)
        "02d": "<span font='20px'></span>",  # Few clouds (day)
        "02n": "<span font='20px'></span>",  # Few clouds (night)
        "03d": "<span font='20px'></span>",  # Scattered clouds
        "03n": "<span font='20px'></span>",
        "04d": "<span font='20px'></span>",  # Broken clouds
        "04n": "<span font='20px'></span>",
        "09d": "<span font='20px'></span>",  # Showers
        "09n": "<span font='20px'></span>",
        "10d": "<span font='20px'></span>",  # Rain (day)
        "10n": "<span font='20px'></span>",  # Rain (night)
        "11d": "<span font='20px'></span>",  # Thunderstorm
        "11n": "<span font='20px'></span>",
        "13d": "<span font='20px'></span>",  # Snow
        "13n": "<span font='20px'></span>",
        "50d": "<span font='20px'></span>",  # Mist/fog
        "50n": "<span font='20px'></span>"
    }

}

class WeatherModule:
    def __init__(self):
        self.config = self.load_config()
        self.ensure_dirs()
        
    def ensure_dirs(self):
        """Ensure cache directory exists"""
        CACHE_DIR.mkdir(parents=True, exist_ok=True)

    def load_config(self):
        """Load config file or use defaults"""
        try:
            with open(CONFIG_FILE) as f:
                config = json.load(f)
                return {**DEFAULT_CONFIG, **config}
        except Exception as e:
            print(f"Config error: {e}, using defaults", file=sys.stderr)
            return DEFAULT_CONFIG

    def get_weather(self):
        """Get weather data from API or cache"""
        # Use cache if valid
        if self.cache_valid():
            try:
                return self.load_cache()
            except:
                pass
        
        # Fetch fresh data
        try:
            weather = self.fetch_weather()
            self.save_cache(weather)
            return weather
        except Exception as e:
            print(f"Weather error: {e}", file=sys.stderr)
            if CACHE_FILE.exists():
                return self.load_cache()
            return {"error": str(e)}

    def cache_valid(self):
        """Check if cache is still valid"""
        if not CACHE_FILE.exists():
            return False
        cache_age = datetime.now() - datetime.fromtimestamp(CACHE_FILE.stat().st_mtime)
        return cache_age < timedelta(seconds=self.config["update_interval"])

    def load_cache(self):
        """Load cached weather data"""
        with open(CACHE_FILE) as f:
            return json.load(f)

    def save_cache(self, data):
        """Save weather data to cache"""
        with open(CACHE_FILE, 'w') as f:
            json.dump(data, f)

    def fetch_weather(self):
        """Fetch weather from configured provider"""
        if self.config["provider"] == "openweathermap":
            return self.fetch_openweathermap()
        return self.fetch_weatherapi()

    def fetch_openweathermap(self):
        """Fetch from OpenWeatherMap API"""
        url = (
            f"https://api.openweathermap.org/data/2.5/weather?"
            f"q={self.config['location']}&"
            f"appid={self.config['api_key']}&"
            f"units={self.config['units']}"
        )
        res = requests.get(url, timeout=10)
        data = res.json()
        
        if res.status_code != 200:
            raise Exception(data.get("message", "API error"))
        
        return {
            "temp": round(data["main"]["temp"]),
            "unit": "C" if self.config["units"] == "metric" else "F",
            "conditions": data["weather"][0]["description"].title(),
            "icon_code": data["weather"][0]["icon"],
            "humidity": data["main"]["humidity"],
            "wind": round(data["wind"]["speed"]),
            "wind_unit": "km/h" if self.config["units"] == "metric" else "mph",
            "updated": datetime.now().strftime("%H:%M")
        }

    def fetch_weatherapi(self):
        """Fetch from WeatherAPI.com"""
        url = (
            f"http://api.weatherapi.com/v1/current.json?"
            f"key={self.config['api_key']}&"
            f"q={self.config['location']}"
        )
        res = requests.get(url, timeout=10)
        data = res.json()
        
        if "error" in data:
            raise Exception(data["error"]["message"])
        
        is_metric = self.config["units"] == "metric"
        return {
            "temp": round(data["current"]["temp_c"] if is_metric else data["current"]["temp_f"]),
            "unit": "C" if is_metric else "F",
            "conditions": data["current"]["condition"]["text"],
            "icon_code": data["current"]["condition"]["icon"][-7:-4],  # Extract icon code
            "humidity": data["current"]["humidity"],
            "wind": round(data["current"]["wind_kph"] if is_metric else data["current"]["wind_mph"]),
            "wind_unit": "km/h" if is_metric else "mph",
            "updated": datetime.now().strftime("%H:%M")
        }

    def format_output(self, weather):
        """Format output for Waybar with size adjustments"""
        if "error" in weather:
            return {
                "text": "<span size='large'>⚠️</span> Weather Error",
                "tooltip": weather["error"],
                "class": "weather-error"
            }

        icon = self.config["icons"].get(weather["icon_code"], "⛅️")
        
        # Format the output with size parameters
        formatted_text = self.config["format"].format(
            icon_size=self.config["icon_size"],
            text_size=self.config["text_size"],
            icon=icon,
            **weather
        )

        return {
            "text": formatted_text,
            "tooltip": self.config["tooltip_format"].format(**weather),
            "class": "weather"
        }

if __name__ == "__main__":
    try:
        weather = WeatherModule()
        data = weather.get_weather()
        output = weather.format_output(data)
        print(json.dumps(output))
    except Exception as e:
        print(json.dumps({
            "text": "<span size='large'>⚠️</span> Weather",
            "tooltip": f"Critical error: {str(e)}",
            "class": "weather-error"
        }))
