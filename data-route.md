## SearchFlight
1. **POST**
{
    "departure_airport_code": "HAN",
    "arrival_airport_code": "SGN",
    "departure_date": "01/08/2025",
    "airline_ids": [],
    "flight_class": "business",
    "passenger": {
        "adults": 1,
        "children":0,
        "infant": 0

    },
    "page": 1,
    "limit": 50,
    "sort_by": "price",
    "sort_order": "asc"
}

2. **RESPONSE**
{
    "data": {
        "arrival_airport": "SGN",
        "arrival_date": "",
        "departure_airport": "HAN",
        "departure_date": "01/08/2025",
        "flight_class": "business",
        "limit": 50,
        "page": 1,
        "passengers": {
            "adults": 1,
            "children": 0,
            "infants": 0
        },
        "search_results": [
            {
                "flight_id": 68,
                "flight_class_id": 70,
                "flight_number": "BL192",
                "airline_id": 5,
                "airline_name": "Bamboo Airways",
                "logo_url": "https://imgs.search.brave.com/cA3Hp7bLO1meOHKsX4sDz_1wnVjNTJYJ5qdQHXGHVHc/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbmt5/dGh1YXRzby5jb20v/dXBsb2Fkcy90aHVt/Ym5haWxzLzgwMC8y/MDIxLzA5L2xvZ28t/YmFtYm9vLWFpcndh/eXMtaW5reXRodWF0/c28tMTMtMTYtMjkt/NTQuanBn",
                "departure_airport_code": "HAN",
                "arrival_airport_code": "SGN",
                "departure_airport": "Sân Bay Nội Bài",
                "arrival_airport": "Sân Bay Tân Sơn Nhất",
                "departure_time": "2025-08-01T09:30:00Z",
                "arrival_time": "2025-08-01T11:45:00Z",
                "duration_minutes": 135,
                "stops_count": 0,
                "distance": 1166,
                "flight_class": "economy",
                "total_seats": 150,
                "fare_class_details": {
                    "fare_class_code": "Q",
                    "cabin_class": "Economy Class",
                    "refundable": false,
                    "changeable": false,
                    "baggage_kg": "1 kiện x 23kg (miễn phí)",
                    "description": "Discounted Economy: Vé rẻ, không hoàn tiền, thay đổi hạn chế.",
                    "refund_change_policy": "Không hoàn vé, đổi vé mất phí 500k"
                },
                "pricing": {
                    "base_prices": {
                        "adult": 876621,
                        "child": 0,
                        "infant": 0
                    },
                    "total_prices": {
                        "adult": 1645621,
                        "child": 0,
                        "infant": 0
                    },
                    "taxes": {
                        "adult": 769000
                    },
                    "grand_total": 1645621,
                    "currency": "VND"
                },
                "tax_and_fees": 769000
            },
            {
                "flight_id": 65,
                "flight_class_id": 67,
                "flight_number": "BL190",
                "airline_id": 5,
                "airline_name": "Bamboo Airways",
                "logo_url": "https://imgs.search.brave.com/cA3Hp7bLO1meOHKsX4sDz_1wnVjNTJYJ5qdQHXGHVHc/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbmt5/dGh1YXRzby5jb20v/dXBsb2Fkcy90aHVt/Ym5haWxzLzgwMC8y/MDIxLzA5L2xvZ28t/YmFtYm9vLWFpcndh/eXMtaW5reXRodWF0/c28tMTMtMTYtMjkt/NTQuanBn",
                "departure_airport_code": "HAN",
                "arrival_airport_code": "SGN",
                "departure_airport": "Sân Bay Nội Bài",
                "arrival_airport": "Sân Bay Tân Sơn Nhất",
                "departure_time": "2025-08-01T09:30:00Z",
                "arrival_time": "2025-08-01T11:45:00Z",
                "duration_minutes": 135,
                "stops_count": 0,
                "distance": 1166,
                "flight_class": "economy",
                "total_seats": 150,
                "fare_class_details": {
                    "fare_class_code": "Q",
                    "cabin_class": "Economy Class",
                    "refundable": false,
                    "changeable": false,
                    "baggage_kg": "1 kiện x 23kg (miễn phí)",
                    "description": "Discounted Economy: Vé rẻ, không hoàn tiền, thay đổi hạn chế.",
                    "refund_change_policy": "Không hoàn vé, đổi vé mất phí 500k"
                },
                "pricing": {
                    "base_prices": {
                        "adult": 876621,
                        "child": 0,
                        "infant": 0
                    },
                    "total_prices": {
                        "adult": 1645621,
                        "child": 0,
                        "infant": 0
                    },
                    "taxes": {
                        "adult": 769000
                    },
                    "grand_total": 1645621,
                    "currency": "VND"
                },
                "tax_and_fees": 769000
            },
            {
                "flight_id": 53,
                "flight_class_id": 55,
                "flight_number": "VJ1173",
                "airline_id": 2,
                "airline_name": "VietJet Air",
                "logo_url": "https://imgs.search.brave.com/lsC-ppx_-3tEUtauExK9kfP6t1miKqTOb9sXu-Sd56Y/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9qaWtl/cmFnZW5jeTM3NGIw/LnphcHdwLmNvbS9x/OmkvcjowL3dwOjEv/dzoxL3U6aHR0cHM6/Ly9tb25kaWFsYnJh/bmQuY29tL3dwLWNv/bnRlbnQvdXBsb2Fk/cy8yMDI0LzAyL3Zp/ZXRqZXRhaXIuY29t/LWxvZ28tYnJhbmRs/b2dvcy5uZXRfLnBu/Zw",
                "departure_airport_code": "HAN",
                "arrival_airport_code": "SGN",
                "departure_airport": "Sân Bay Nội Bài",
                "arrival_airport": "Sân Bay Tân Sơn Nhất",
                "departure_time": "2025-08-01T21:55:00Z",
                "arrival_time": "2025-08-02T00:05:00Z",
                "duration_minutes": 130,
                "stops_count": 0,
                "distance": 1166,
                "flight_class": "economy",
                "total_seats": 150,
                "fare_class_details": {
                    "fare_class_code": "Z",
                    "cabin_class": "Business Class",
                    "refundable": false,
                    "changeable": false,
                    "baggage_kg": "2 kiện x 32kg (miễn phí)",
                    "description": "Discounted Business: Vé khuyến mãi sâu, hạn chế cao.",
                    "refund_change_policy": "Hoàn vé mất phí 20%, đổi vé miễn phí"
                },
                "pricing": {
                    "base_prices": {
                        "adult": 890000,
                        "child": 0,
                        "infant": 0
                    },
                    "total_prices": {
                        "adult": 1595000,
                        "child": 0,
                        "infant": 0
                    },
                    "taxes": {
                        "adult": 705000
                    },
                    "grand_total": 1595000,
                    "currency": "VND"
                },
                "tax_and_fees": 705000
            },
            {
                "flight_id": 54,
                "flight_class_id": 56,
                "flight_number": "VJ1165",
                "airline_id": 2,
                "airline_name": "VietJet Air",
                "logo_url": "https://imgs.search.brave.com/lsC-ppx_-3tEUtauExK9kfP6t1miKqTOb9sXu-Sd56Y/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9qaWtl/cmFnZW5jeTM3NGIw/LnphcHdwLmNvbS9x/OmkvcjowL3dwOjEv/dzoxL3U6aHR0cHM6/Ly9tb25kaWFsYnJh/bmQuY29tL3dwLWNv/bnRlbnQvdXBsb2Fk/cy8yMDI0LzAyL3Zp/ZXRqZXRhaXIuY29t/LWxvZ28tYnJhbmRs/b2dvcy5uZXRfLnBu/Zw",
                "departure_airport_code": "HAN",
                "arrival_airport_code": "SGN",
                "departure_airport": "Sân Bay Nội Bài",
                "arrival_airport": "Sân Bay Tân Sơn Nhất",
                "departure_time": "2025-08-01T22:40:00Z",
                "arrival_time": "2025-08-02T00:50:00Z",
                "duration_minutes": 130,
                "stops_count": 0,
                "distance": 1166,
                "flight_class": "economy",
                "total_seats": 150,
                "fare_class_details": {
                    "fare_class_code": "Z",
                    "cabin_class": "Business Class",
                    "refundable": false,
                    "changeable": false,
                    "baggage_kg": "2 kiện x 32kg (miễn phí)",
                    "description": "Discounted Business: Vé khuyến mãi sâu, hạn chế cao.",
                    "refund_change_policy": "Hoàn vé mất phí 20%, đổi vé miễn phí"
                },
                "pricing": {
                    "base_prices": {
                        "adult": 890000,
                        "child": 0,
                        "infant": 0
                    },
                    "total_prices": {
                        "adult": 1595000,
                        "child": 0,
                        "infant": 0
                    },
                    "taxes": {
                        "adult": 705000
                    },
                    "grand_total": 1595000,
                    "currency": "VND"
                },
                "tax_and_fees": 705000
            },
            {
                "flight_id": 58,
                "flight_class_id": 60,
                "flight_number": "VN6026",
                "airline_id": 1,
                "airline_name": "Vietnam Airlines",
                "logo_url": "https://imgs.search.brave.com/fsizGeuSeloHhBMe6uaAKS7aEIEeXElwI9YVpfY3bY4/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aW5o/b2NuZXdzLmNvbS93/cC1jb250ZW50L3Vw/bG9hZHMvMjAyNC8w/Ni92aWV0bmFtLWFp/cmxpbmVzLWxvZ28t/dmVjdG9yLmpwZw",
                "departure_airport_code": "HAN",
                "arrival_airport_code": "SGN",
                "departure_airport": "Sân Bay Nội Bài",
                "arrival_airport": "Sân Bay Tân Sơn Nhất",
                "departure_time": "2025-08-01T23:55:00Z",
                "arrival_time": "2025-08-02T02:10:00Z",
                "duration_minutes": 130,
                "stops_count": 0,
                "distance": 1166,
                "flight_class": "economy",
                "total_seats": 150,
                "fare_class_details": {
                    "fare_class_code": "L",
                    "cabin_class": "Economy Class",
                    "refundable": false,
                    "changeable": false,
                    "baggage_kg": "1 kiện x 23kg (miễn phí)",
                    "description": "Discounted Economy: Vé rẻ, không hoàn tiền, thay đổi có phí cao.",
                    "refund_change_policy": "Không hoàn vé, đổi vé mất phí 500k"
                },
                "pricing": {
                    "base_prices": {
                        "adult": 1008000,
                        "child": 0,
                        "infant": 0
                    },
                    "total_prices": {
                        "adult": 1776400,
                        "child": 0,
                        "infant": 0
                    },
                    "taxes": {
                        "adult": 768400
                    },
                    "grand_total": 1776400,
                    "currency": "VND"
                },
                "tax_and_fees": 768400
            },
            {
                "flight_id": 57,
                "flight_class_id": 59,
                "flight_number": "VN6025",
                "airline_id": 1,
                "airline_name": "Vietnam Airlines",
                "logo_url": "https://imgs.search.brave.com/fsizGeuSeloHhBMe6uaAKS7aEIEeXElwI9YVpfY3bY4/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aW5o/b2NuZXdzLmNvbS93/cC1jb250ZW50L3Vw/bG9hZHMvMjAyNC8w/Ni92aWV0bmFtLWFp/cmxpbmVzLWxvZ28t/dmVjdG9yLmpwZw",
                "departure_airport_code": "HAN",
                "arrival_airport_code": "SGN",
                "departure_airport": "Sân Bay Nội Bài",
                "arrival_airport": "Sân Bay Tân Sơn Nhất",
                "departure_time": "2025-08-01T23:00:00Z",
                "arrival_time": "2025-08-02T01:10:00Z",
                "duration_minutes": 130,
                "stops_count": 0,
                "distance": 1166,
                "flight_class": "economy",
                "total_seats": 150,
                "fare_class_details": {
                    "fare_class_code": "L",
                    "cabin_class": "Economy Class",
                    "refundable": false,
                    "changeable": false,
                    "baggage_kg": "1 kiện x 23kg (miễn phí)",
                    "description": "Discounted Economy: Vé rẻ, không hoàn tiền, thay đổi có phí cao.",
                    "refund_change_policy": "Không hoàn vé, đổi vé mất phí 500k"
                },
                "pricing": {
                    "base_prices": {
                        "adult": 1008000,
                        "child": 0,
                        "infant": 0
                    },
                    "total_prices": {
                        "adult": 1776400,
                        "child": 0,
                        "infant": 0
                    },
                    "taxes": {
                        "adult": 768400
                    },
                    "grand_total": 1776400,
                    "currency": "VND"
                },
                "tax_and_fees": 768400
            },
            {
                "flight_id": 55,
                "flight_class_id": 57,
                "flight_number": "VJ1151",
                "airline_id": 2,
                "airline_name": "VietJet Air",
                "logo_url": "https://imgs.search.brave.com/lsC-ppx_-3tEUtauExK9kfP6t1miKqTOb9sXu-Sd56Y/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9qaWtl/cmFnZW5jeTM3NGIw/LnphcHdwLmNvbS9x/OmkvcjowL3dwOjEv/dzoxL3U6aHR0cHM6/Ly9tb25kaWFsYnJh/bmQuY29tL3dwLWNv/bnRlbnQvdXBsb2Fk/cy8yMDI0LzAyL3Zp/ZXRqZXRhaXIuY29t/LWxvZ28tYnJhbmRs/b2dvcy5uZXRfLnBu/Zw",
                "departure_airport_code": "HAN",
                "arrival_airport_code": "SGN",
                "departure_airport": "Sân Bay Nội Bài",
                "arrival_airport": "Sân Bay Tân Sơn Nhất",
                "departure_time": "2025-08-01T19:50:00Z",
                "arrival_time": "2025-08-01T21:40:00Z",
                "duration_minutes": 130,
                "stops_count": 0,
                "distance": 1166,
                "flight_class": "economy",
                "total_seats": 150,
                "fare_class_details": {
                    "fare_class_code": "W",
                    "cabin_class": "Premium Economy",
                    "refundable": true,
                    "changeable": true,
                    "baggage_kg": "2 kiện x 23kg (miễn phí)",
                    "description": "Full-fare Premium Economy: Vé linh hoạt, ghế rộng, priority perks.",
                    "refund_change_policy": "Không hoàn vé, đổi vé mất phí 200k"
                },
                "pricing": {
                    "base_prices": {
                        "adult": 1010000,
                        "child": 0,
                        "infant": 0
                    },
                    "total_prices": {
                        "adult": 1725000,
                        "child": 0,
                        "infant": 0
                    },
                    "taxes": {
                        "adult": 715000
                    },
                    "grand_total": 1725000,
                    "currency": "VND"
                },
                "tax_and_fees": 715000
            },
            {
                "flight_id": 56,
                "flight_class_id": 58,
                "flight_number": "VJ157",
                "airline_id": 2,
                "airline_name": "VietJet Air",
                "logo_url": "https://imgs.search.brave.com/lsC-ppx_-3tEUtauExK9kfP6t1miKqTOb9sXu-Sd56Y/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9qaWtl/cmFnZW5jeTM3NGIw/LnphcHdwLmNvbS9x/OmkvcjowL3dwOjEv/dzoxL3U6aHR0cHM6/Ly9tb25kaWFsYnJh/bmQuY29tL3dwLWNv/bnRlbnQvdXBsb2Fk/cy8yMDI0LzAyL3Zp/ZXRqZXRhaXIuY29t/LWxvZ28tYnJhbmRs/b2dvcy5uZXRfLnBu/Zw",
                "departure_airport_code": "HAN",
                "arrival_airport_code": "SGN",
                "departure_airport": "Sân Bay Nội Bài",
                "arrival_airport": "Sân Bay Tân Sơn Nhất",
                "departure_time": "2025-08-01T19:20:00Z",
                "arrival_time": "2025-08-01T21:30:00Z",
                "duration_minutes": 130,
                "stops_count": 0,
                "distance": 1166,
                "flight_class": "economy",
                "total_seats": 150,
                "fare_class_details": {
                    "fare_class_code": "W",
                    "cabin_class": "Premium Economy",
                    "refundable": true,
                    "changeable": true,
                    "baggage_kg": "2 kiện x 23kg (miễn phí)",
                    "description": "Full-fare Premium Economy: Vé linh hoạt, ghế rộng, priority perks.",
                    "refund_change_policy": "Không hoàn vé, đổi vé mất phí 200k"
                },
                "pricing": {
                    "base_prices": {
                        "adult": 1010000,
                        "child": 0,
                        "infant": 0
                    },
                    "total_prices": {
                        "adult": 1725000,
                        "child": 0,
                        "infant": 0
                    },
                    "taxes": {
                        "adult": 715000
                    },
                    "grand_total": 1725000,
                    "currency": "VND"
                },
                "tax_and_fees": 715000
            },
            {
                "flight_id": 60,
                "flight_class_id": 62,
                "flight_number": "QH288",
                "airline_id": 5,
                "airline_name": "Bamboo Airways",
                "logo_url": "https://imgs.search.brave.com/cA3Hp7bLO1meOHKsX4sDz_1wnVjNTJYJ5qdQHXGHVHc/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbmt5/dGh1YXRzby5jb20v/dXBsb2Fkcy90aHVt/Ym5haWxzLzgwMC8y/MDIxLzA5L2xvZ28t/YmFtYm9vLWFpcndh/eXMtaW5reXRodWF0/c28tMTMtMTYtMjkt/NTQuanBn",
                "departure_airport_code": "HAN",
                "arrival_airport_code": "SGN",
                "departure_airport": "Sân Bay Nội Bài",
                "arrival_airport": "Sân Bay Tân Sơn Nhất",
                "departure_time": "2025-08-01T22:15:00Z",
                "arrival_time": "2025-08-02T00:30:00Z",
                "duration_minutes": 130,
                "stops_count": 0,
                "distance": 1166,
                "flight_class": "economy",
                "total_seats": 150,
                "fare_class_details": {
                    "fare_class_code": "Q",
                    "cabin_class": "Economy Class",
                    "refundable": false,
                    "changeable": false,
                    "baggage_kg": "1 kiện x 23kg (miễn phí)",
                    "description": "Discounted Economy: Vé rẻ, không hoàn tiền, thay đổi hạn chế.",
                    "refund_change_policy": "Không hoàn vé, đổi vé mất phí 500k"
                },
                "pricing": {
                    "base_prices": {
                        "adult": 1069000,
                        "child": 0,
                        "infant": 0
                    },
                    "total_prices": {
                        "adult": 1838000,
                        "child": 0,
                        "infant": 0
                    },
                    "taxes": {
                        "adult": 769000
                    },
                    "grand_total": 1838000,
                    "currency": "VND"
                },
                "tax_and_fees": 769000
            },
            {
                "flight_id": 59,
                "flight_class_id": 61,
                "flight_number": "QH289",
                "airline_id": 5,
                "airline_name": "Bamboo Airways",
                "logo_url": "https://imgs.search.brave.com/cA3Hp7bLO1meOHKsX4sDz_1wnVjNTJYJ5qdQHXGHVHc/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbmt5/dGh1YXRzby5jb20v/dXBsb2Fkcy90aHVt/Ym5haWxzLzgwMC8y/MDIxLzA5L2xvZ28t/YmFtYm9vLWFpcndh/eXMtaW5reXRodWF0/c28tMTMtMTYtMjkt/NTQuanBn",
                "departure_airport_code": "HAN",
                "arrival_airport_code": "SGN",
                "departure_airport": "Sân Bay Nội Bài",
                "arrival_airport": "Sân Bay Tân Sơn Nhất",
                "departure_time": "2025-08-01T21:45:00Z",
                "arrival_time": "2025-08-01T23:59:00Z",
                "duration_minutes": 130,
                "stops_count": 0,
                "distance": 1166,
                "flight_class": "economy",
                "total_seats": 150,
                "fare_class_details": {
                    "fare_class_code": "Q",
                    "cabin_class": "Economy Class",
                    "refundable": false,
                    "changeable": false,
                    "baggage_kg": "1 kiện x 23kg (miễn phí)",
                    "description": "Discounted Economy: Vé rẻ, không hoàn tiền, thay đổi hạn chế.",
                    "refund_change_policy": "Không hoàn vé, đổi vé mất phí 500k"
                },
                "pricing": {
                    "base_prices": {
                        "adult": 1069000,
                        "child": 0,
                        "infant": 0
                    },
                    "total_prices": {
                        "adult": 1838000,
                        "child": 0,
                        "infant": 0
                    },
                    "taxes": {
                        "adult": 769000
                    },
                    "grand_total": 1838000,
                    "currency": "VND"
                },
                "tax_and_fees": 769000
            }
        ],
        "sort_by": "price",
        "sort_order": "asc",
        "total_count": 10,
        "total_pages": 1
    },
    "status": true,
    "errorCode": "SUCCESS",
    "errorMessage": "Successfully searched flights for user"
}

# RoundTripSearch
1. **POST**
{
    "departure_airport_code": "HAN",
    "arrival_airport_code": "SGN",
    "departure_date": "01/08/2025",
    "return_date": "04/08/2025",
    "airline_ids": [2],
    "flight_class": "all",
    "passengers": {
        "adults": 1
    },
    "page": 1,
    "limit": 50,
    "sort_by": "price",
    "sort_order": "asc"
}

2. **RESPONSE**
{
    "data": {
        "arrival_airport": "SGN",
        "departure_airport": "HAN",
        "departure_date": "01/08/2025",
        "flight_class": "all",
        "inbound_total_count": 4,
        "inbound_total_pages": 1,
        "limit": 50,
        "outbound_total_count": 10,
        "outbound_total_pages": 1,
        "page": 1,
        "passenger_count": {
            "adults": 1,
            "children": 0,
            "infants": 0
        },
        "return_date": "04/08/2025",
        "search_results": {
            "outbound_flights": [
                {
                    "flight_id": 53,
                    "flight_class_id": 55,
                    "flight_number": "VJ1173",
                    "airline_id": 2,
                    "airline_name": "VietJet Air",
                    "logo_url": "https://imgs.search.brave.com/lsC-ppx_-3tEUtauExK9kfP6t1miKqTOb9sXu-Sd56Y/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9qaWtl/cmFnZW5jeTM3NGIw/LnphcHdwLmNvbS9x/OmkvcjowL3dwOjEv/dzoxL3U6aHR0cHM6/Ly9tb25kaWFsYnJh/bmQuY29tL3dwLWNv/bnRlbnQvdXBsb2Fk/cy8yMDI0LzAyL3Zp/ZXRqZXRhaXIuY29t/LWxvZ28tYnJhbmRs/b2dvcy5uZXRfLnBu/Zw",
                    "departure_airport_code": "HAN",
                    "arrival_airport_code": "SGN",
                    "departure_airport": "Sân Bay Nội Bài",
                    "arrival_airport": "Sân Bay Tân Sơn Nhất",
                    "departure_time": "2025-08-01T21:55:00Z",
                    "arrival_time": "2025-08-02T00:05:00Z",
                    "duration_minutes": 130,
                    "stops_count": 0,
                    "distance": 1166,
                    "flight_class": "economy",
                    "total_seats": 150,
                    "fare_class_details": {
                        "fare_class_code": "Z",
                        "cabin_class": "Business Class",
                        "refundable": false,
                        "changeable": false,
                        "baggage_kg": "2 kiện x 32kg (miễn phí)",
                        "description": "Discounted Business: Vé khuyến mãi sâu, hạn chế cao.",
                        "refund_change_policy": "Hoàn vé mất phí 20%, đổi vé miễn phí"
                    },
                    "pricing": {
                        "base_prices": {
                            "adult": 890000,
                            "child": 0,
                            "infant": 0
                        },
                        "total_prices": {
                            "adult": 1595000,
                            "child": 0,
                            "infant": 0
                        },
                        "taxes": {
                            "adult": 705000
                        },
                        "grand_total": 1595000,
                        "currency": "VND"
                    },
                    "tax_and_fees": 705000
                },
                {
                    "flight_id": 54,
                    "flight_class_id": 56,
                    "flight_number": "VJ1165",
                    "airline_id": 2,
                    "airline_name": "VietJet Air",
                    "logo_url": "https://imgs.search.brave.com/lsC-ppx_-3tEUtauExK9kfP6t1miKqTOb9sXu-Sd56Y/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9qaWtl/cmFnZW5jeTM3NGIw/LnphcHdwLmNvbS9x/OmkvcjowL3dwOjEv/dzoxL3U6aHR0cHM6/Ly9tb25kaWFsYnJh/bmQuY29tL3dwLWNv/bnRlbnQvdXBsb2Fk/cy8yMDI0LzAyL3Zp/ZXRqZXRhaXIuY29t/LWxvZ28tYnJhbmRs/b2dvcy5uZXRfLnBu/Zw",
                    "departure_airport_code": "HAN",
                    "arrival_airport_code": "SGN",
                    "departure_airport": "Sân Bay Nội Bài",
                    "arrival_airport": "Sân Bay Tân Sơn Nhất",
                    "departure_time": "2025-08-01T22:40:00Z",
                    "arrival_time": "2025-08-02T00:50:00Z",
                    "duration_minutes": 130,
                    "stops_count": 0,
                    "distance": 1166,
                    "flight_class": "economy",
                    "total_seats": 150,
                    "fare_class_details": {
                        "fare_class_code": "Z",
                        "cabin_class": "Business Class",
                        "refundable": false,
                        "changeable": false,
                        "baggage_kg": "2 kiện x 32kg (miễn phí)",
                        "description": "Discounted Business: Vé khuyến mãi sâu, hạn chế cao.",
                        "refund_change_policy": "Hoàn vé mất phí 20%, đổi vé miễn phí"
                    },
                    "pricing": {
                        "base_prices": {
                            "adult": 890000,
                            "child": 0,
                            "infant": 0
                        },
                        "total_prices": {
                            "adult": 1595000,
                            "child": 0,
                            "infant": 0
                        },
                        "taxes": {
                            "adult": 705000
                        },
                        "grand_total": 1595000,
                        "currency": "VND"
                    },
                    "tax_and_fees": 705000
                },
                {
                    "flight_id": 55,
                    "flight_class_id": 57,
                    "flight_number": "VJ1151",
                    "airline_id": 2,
                    "airline_name": "VietJet Air",
                    "logo_url": "https://imgs.search.brave.com/lsC-ppx_-3tEUtauExK9kfP6t1miKqTOb9sXu-Sd56Y/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9qaWtl/cmFnZW5jeTM3NGIw/LnphcHdwLmNvbS9x/OmkvcjowL3dwOjEv/dzoxL3U6aHR0cHM6/Ly9tb25kaWFsYnJh/bmQuY29tL3dwLWNv/bnRlbnQvdXBsb2Fk/cy8yMDI0LzAyL3Zp/ZXRqZXRhaXIuY29t/LWxvZ28tYnJhbmRs/b2dvcy5uZXRfLnBu/Zw",
                    "departure_airport_code": "HAN",
                    "arrival_airport_code": "SGN",
                    "departure_airport": "Sân Bay Nội Bài",
                    "arrival_airport": "Sân Bay Tân Sơn Nhất",
                    "departure_time": "2025-08-01T19:50:00Z",
                    "arrival_time": "2025-08-01T21:40:00Z",
                    "duration_minutes": 130,
                    "stops_count": 0,
                    "distance": 1166,
                    "flight_class": "economy",
                    "total_seats": 150,
                    "fare_class_details": {
                        "fare_class_code": "W",
                        "cabin_class": "Premium Economy",
                        "refundable": true,
                        "changeable": true,
                        "baggage_kg": "2 kiện x 23kg (miễn phí)",
                        "description": "Full-fare Premium Economy: Vé linh hoạt, ghế rộng, priority perks.",
                        "refund_change_policy": "Không hoàn vé, đổi vé mất phí 200k"
                    },
                    "pricing": {
                        "base_prices": {
                            "adult": 1010000,
                            "child": 0,
                            "infant": 0
                        },
                        "total_prices": {
                            "adult": 1725000,
                            "child": 0,
                            "infant": 0
                        },
                        "taxes": {
                            "adult": 715000
                        },
                        "grand_total": 1725000,
                        "currency": "VND"
                    },
                    "tax_and_fees": 715000
                },
                {
                    "flight_id": 56,
                    "flight_class_id": 58,
                    "flight_number": "VJ157",
                    "airline_id": 2,
                    "airline_name": "VietJet Air",
                    "logo_url": "https://imgs.search.brave.com/lsC-ppx_-3tEUtauExK9kfP6t1miKqTOb9sXu-Sd56Y/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9qaWtl/cmFnZW5jeTM3NGIw/LnphcHdwLmNvbS9x/OmkvcjowL3dwOjEv/dzoxL3U6aHR0cHM6/Ly9tb25kaWFsYnJh/bmQuY29tL3dwLWNv/bnRlbnQvdXBsb2Fk/cy8yMDI0LzAyL3Zp/ZXRqZXRhaXIuY29t/LWxvZ28tYnJhbmRs/b2dvcy5uZXRfLnBu/Zw",
                    "departure_airport_code": "HAN",
                    "arrival_airport_code": "SGN",
                    "departure_airport": "Sân Bay Nội Bài",
                    "arrival_airport": "Sân Bay Tân Sơn Nhất",
                    "departure_time": "2025-08-01T19:20:00Z",
                    "arrival_time": "2025-08-01T21:30:00Z",
                    "duration_minutes": 130,
                    "stops_count": 0,
                    "distance": 1166,
                    "flight_class": "economy",
                    "total_seats": 150,
                    "fare_class_details": {
                        "fare_class_code": "W",
                        "cabin_class": "Premium Economy",
                        "refundable": true,
                        "changeable": true,
                        "baggage_kg": "2 kiện x 23kg (miễn phí)",
                        "description": "Full-fare Premium Economy: Vé linh hoạt, ghế rộng, priority perks.",
                        "refund_change_policy": "Không hoàn vé, đổi vé mất phí 200k"
                    },
                    "pricing": {
                        "base_prices": {
                            "adult": 1010000,
                            "child": 0,
                            "infant": 0
                        },
                        "total_prices": {
                            "adult": 1725000,
                            "child": 0,
                            "infant": 0
                        },
                        "taxes": {
                            "adult": 715000
                        },
                        "grand_total": 1725000,
                        "currency": "VND"
                    },
                    "tax_and_fees": 715000
                }
            ],
            "inbound_flights": [
                {
                    "flight_id": 64,
                    "flight_class_id": 66,
                    "flight_number": "VJ1181",
                    "airline_id": 2,
                    "airline_name": "VietJet Air",
                    "logo_url": "https://imgs.search.brave.com/lsC-ppx_-3tEUtauExK9kfP6t1miKqTOb9sXu-Sd56Y/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9qaWtl/cmFnZW5jeTM3NGIw/LnphcHdwLmNvbS9x/OmkvcjowL3dwOjEv/dzoxL3U6aHR0cHM6/Ly9tb25kaWFsYnJh/bmQuY29tL3dwLWNv/bnRlbnQvdXBsb2Fk/cy8yMDI0LzAyL3Zp/ZXRqZXRhaXIuY29t/LWxvZ28tYnJhbmRs/b2dvcy5uZXRfLnBu/Zw",
                    "departure_airport_code": "SGN",
                    "arrival_airport_code": "HAN",
                    "departure_airport": "Sân Bay Tân Sơn Nhất",
                    "arrival_airport": "Sân Bay Nội Bài",
                    "departure_time": "2025-08-04T06:30:00Z",
                    "arrival_time": "2025-08-04T08:40:00Z",
                    "duration_minutes": 130,
                    "stops_count": 0,
                    "distance": 1166,
                    "flight_class": "economy",
                    "total_seats": 150,
                    "fare_class_details": {
                        "fare_class_code": "W",
                        "cabin_class": "Premium Economy",
                        "refundable": true,
                        "changeable": true,
                        "baggage_kg": "2 kiện x 23kg (miễn phí)",
                        "description": "Full-fare Premium Economy: Vé linh hoạt, ghế rộng, priority perks.",
                        "refund_change_policy": "Không hoàn vé, đổi vé mất phí 200k"
                    },
                    "pricing": {
                        "base_prices": {
                            "adult": 101000,
                            "child": 0,
                            "infant": 0
                        },
                        "total_prices": {
                            "adult": 816000,
                            "child": 0,
                            "infant": 0
                        },
                        "taxes": {
                            "adult": 715000
                        },
                        "grand_total": 816000,
                        "currency": "VND"
                    },
                    "tax_and_fees": 715000
                },
                {
                    "flight_id": 63,
                    "flight_class_id": 65,
                    "flight_number": "VJ1374",
                    "airline_id": 2,
                    "airline_name": "VietJet Air",
                    "logo_url": "https://imgs.search.brave.com/lsC-ppx_-3tEUtauExK9kfP6t1miKqTOb9sXu-Sd56Y/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9qaWtl/cmFnZW5jeTM3NGIw/LnphcHdwLmNvbS9x/OmkvcjowL3dwOjEv/dzoxL3U6aHR0cHM6/Ly9tb25kaWFsYnJh/bmQuY29tL3dwLWNv/bnRlbnQvdXBsb2Fk/cy8yMDI0LzAyL3Zp/ZXRqZXRhaXIuY29t/LWxvZ28tYnJhbmRs/b2dvcy5uZXRfLnBu/Zw",
                    "departure_airport_code": "SGN",
                    "arrival_airport_code": "HAN",
                    "departure_airport": "Sân Bay Tân Sơn Nhất",
                    "arrival_airport": "Sân Bay Nội Bài",
                    "departure_time": "2025-08-04T21:00:00Z",
                    "arrival_time": "2025-08-04T23:10:00Z",
                    "duration_minutes": 130,
                    "stops_count": 0,
                    "distance": 1166,
                    "flight_class": "economy",
                    "total_seats": 150,
                    "fare_class_details": {
                        "fare_class_code": "W",
                        "cabin_class": "Premium Economy",
                        "refundable": true,
                        "changeable": true,
                        "baggage_kg": "2 kiện x 23kg (miễn phí)",
                        "description": "Full-fare Premium Economy: Vé linh hoạt, ghế rộng, priority perks.",
                        "refund_change_policy": "Không hoàn vé, đổi vé mất phí 200k"
                    },
                    "pricing": {
                        "base_prices": {
                            "adult": 101000,
                            "child": 0,
                            "infant": 0
                        },
                        "total_prices": {
                            "adult": 816000,
                            "child": 0,
                            "infant": 0
                        },
                        "taxes": {
                            "adult": 715000
                        },
                        "grand_total": 816000,
                        "currency": "VND"
                    },
                    "tax_and_fees": 715000
                },
                {
                    "flight_id": 61,
                    "flight_class_id": 63,
                    "flight_number": "VJ174",
                    "airline_id": 2,
                    "airline_name": "VietJet Air",
                    "logo_url": "https://imgs.search.brave.com/lsC-ppx_-3tEUtauExK9kfP6t1miKqTOb9sXu-Sd56Y/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9qaWtl/cmFnZW5jeTM3NGIw/LnphcHdwLmNvbS9x/OmkvcjowL3dwOjEv/dzoxL3U6aHR0cHM6/Ly9tb25kaWFsYnJh/bmQuY29tL3dwLWNv/bnRlbnQvdXBsb2Fk/cy8yMDI0LzAyL3Zp/ZXRqZXRhaXIuY29t/LWxvZ28tYnJhbmRs/b2dvcy5uZXRfLnBu/Zw",
                    "departure_airport_code": "SGN",
                    "arrival_airport_code": "HAN",
                    "departure_airport": "Sân Bay Tân Sơn Nhất",
                    "arrival_airport": "Sân Bay Nội Bài",
                    "departure_time": "2025-08-04T20:30:00Z",
                    "arrival_time": "2025-08-04T22:40:00Z",
                    "duration_minutes": 130,
                    "stops_count": 0,
                    "distance": 1166,
                    "flight_class": "economy",
                    "total_seats": 150,
                    "fare_class_details": {
                        "fare_class_code": "Z",
                        "cabin_class": "Business Class",
                        "refundable": false,
                        "changeable": false,
                        "baggage_kg": "2 kiện x 32kg (miễn phí)",
                        "description": "Discounted Business: Vé khuyến mãi sâu, hạn chế cao.",
                        "refund_change_policy": "Hoàn vé mất phí 20%, đổi vé miễn phí"
                    },
                    "pricing": {
                        "base_prices": {
                            "adult": 890000,
                            "child": 0,
                            "infant": 0
                        },
                        "total_prices": {
                            "adult": 1595000,
                            "child": 0,
                            "infant": 0
                        },
                        "taxes": {
                            "adult": 705000
                        },
                        "grand_total": 1595000,
                        "currency": "VND"
                    },
                    "tax_and_fees": 705000
                },
                {
                    "flight_id": 62,
                    "flight_class_id": 64,
                    "flight_number": "VJ1274",
                    "airline_id": 2,
                    "airline_name": "VietJet Air",
                    "logo_url": "https://imgs.search.brave.com/lsC-ppx_-3tEUtauExK9kfP6t1miKqTOb9sXu-Sd56Y/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9qaWtl/cmFnZW5jeTM3NGIw/LnphcHdwLmNvbS9x/OmkvcjowL3dwOjEv/dzoxL3U6aHR0cHM6/Ly9tb25kaWFsYnJh/bmQuY29tL3dwLWNv/bnRlbnQvdXBsb2Fk/cy8yMDI0LzAyL3Zp/ZXRqZXRhaXIuY29t/LWxvZ28tYnJhbmRs/b2dvcy5uZXRfLnBu/Zw",
                    "departure_airport_code": "SGN",
                    "arrival_airport_code": "HAN",
                    "departure_airport": "Sân Bay Tân Sơn Nhất",
                    "arrival_airport": "Sân Bay Nội Bài",
                    "departure_time": "2025-08-04T21:00:00Z",
                    "arrival_time": "2025-08-04T23:10:00Z",
                    "duration_minutes": 130,
                    "stops_count": 0,
                    "distance": 1166,
                    "flight_class": "economy",
                    "total_seats": 150,
                    "fare_class_details": {
                        "fare_class_code": "Z",
                        "cabin_class": "Business Class",
                        "refundable": false,
                        "changeable": false,
                        "baggage_kg": "2 kiện x 32kg (miễn phí)",
                        "description": "Discounted Business: Vé khuyến mãi sâu, hạn chế cao.",
                        "refund_change_policy": "Hoàn vé mất phí 20%, đổi vé miễn phí"
                    },
                    "pricing": {
                        "base_prices": {
                            "adult": 890000,
                            "child": 0,
                            "infant": 0
                        },
                        "total_prices": {
                            "adult": 1595000,
                            "child": 0,
                            "infant": 0
                        },
                        "taxes": {
                            "adult": 705000
                        },
                        "grand_total": 1595000,
                        "currency": "VND"
                    },
                    "tax_and_fees": 705000
                }
            ]
        },
        "sort_by": "price",
        "sort_order": "asc"
    },
    "status": true,
    "errorCode": "SUCCESS",
    "errorMessage": "Successfully searched roundtrip flights"
}

# API
baseurl: http://localhost:3000
search: {{baseURL}}/api/v1/flights/search
RoundTripSearch: {{baseURL}}/api/v1/flights/search/roundtrip