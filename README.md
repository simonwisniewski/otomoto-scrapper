# Otomoto Scrapper

The Otomoto Scrapper is a Ruby-based application designed to extract vehicle listing information from the Otomoto website. This tool is intended for those who wish to analyze vehicle market trends, compare prices, or simply gather data on various types of vehicles available on Otomoto.pl. It automates the process of data collection, providing users with a structured dataset of vehicle listings.

## Features

- **Data Extraction**: Collects detailed information on vehicle listings, including make, model, year, price, and more.
- **Data Export**: Supports exporting the collected data into CSV and PDF format.All exported files are saved in the directory named `reports`

## Getting Started

### Prerequisites

- Ruby (version 2.7 or newer)
- Bundler

### Installation

1. Clone the repository to your local machine:

```bash
git clone https://github.com/simonwisniewski/otomoto-scrapper.git
cd otomoto-scrapper
```

2. Install the required gems:

```bash
bundle install
```

### Usage

```bash
bundle exec ruby main.rb
```

### Tests and Documentation

```bash
rspec

rdoc
```
