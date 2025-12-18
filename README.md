# 🏛️ Coimbra City Guide

A comprehensive mobile travel guide for the city of Coimbra, Portugal. Built with **Flutter**, this application provides tourists with real-time weather updates, categorized points of interest, and the ability to save their favorite locations.

## 📱 Project Overview

This project was developed as part of the Mobile Computing course (AMOV). It demonstrates key Flutter concepts including:
* **Asynchronous Programming:** Handling API calls and local file reading.
* **State Management:** Using `setState` and `FutureBuilder` for dynamic UI updates.
* **Data Persistence:** Storing user favorites locally.
* **External APIs:** Integration with Open-Meteo for live weather data.

## ✨ Key Features

* **🏠 Home Screen:**
    * Displays the current temperature and weather condition in Coimbra using the [Open-Meteo API](https://open-meteo.com/).
    * Dynamic weather icons based on API response codes.

* **🏛️ Categories & POIs:**
    * Browsing of points of interest (Monuments, Museums, etc.) loaded from a local JSON dataset.
    * Detailed view for each location including description, schedule, price, and images.

* **❤️ Favorites System:**
    * Users can mark locations as "Favorites".
    * Data is persisted locally using `shared_preferences`, ensuring favorites remain saved even after closing the app.

## 🛠️ Tech Stack

* **Framework:** Flutter & Dart
* **Networking:** `http` package
* **Persistence:** `shared_preferences`
* **Assets:** Local JSON and Image assets

## 👥 Authors

* **Rui Casaca** - [GitHub Profile](https://github.com/Rui-Kaz)
* **Davi Gama** - [GitHub Profile](https://github.com/DaviGama08)
* **Iolanda Santos** - [GitHub Profile](https://github.com/IolandaHub)

---
*Developed for the Mobile Computing course (AMOV) - 2025.*
