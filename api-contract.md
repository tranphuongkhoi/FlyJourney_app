{
	"info": {
		"_postman_id": "5d47c41f-4d7a-447e-aae2-afaa4969a4ae",
		"name": "FlyJourney",
		"schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json",
		"_exporter_id": "47828928",
		"_collection_link": "https://a88888-3816.postman.co/workspace/Lufian-Api~c0ec986f-d444-4489-8021-67c501ccbfa8/collection/34182506-5d47c41f-4d7a-447e-aae2-afaa4969a4ae?action=share&source=collection_link&creator=47828928"
	},
	"item": [
		{
			"name": "user",
			"item": [
				{
					"name": "Register",
					"request": {
						"method": "POST",
						"header": [],
						"body": {
							"mode": "raw",
							"raw": "{\r\n    \"email\": \"devtest01@mailnesia.com\",\r\n    \"password\": \"abcd1234\",\r\n    \"name\": \"Ken Tran\",\r\n    \"phone\": \"0936912309\"\r\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "{{baseURL}}/api/v1/auth/register",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"auth",
								"register"
							]
						}
					},
					"response": []
				},
				{
					"name": "Confirm_Register",
					"request": {
						"method": "POST",
						"header": [],
						"body": {
							"mode": "raw",
							"raw": "{\r\n   \r\n    \"name\":\"Ken Tran\",\r\n    \"email\": \"devtest01@mailnesia.com\",\r\n    \"otp\":\"156134\",\r\n    \"phone\":\"0936912309\",\r\n    \"password\":\"abcd1234\"\r\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "{{baseURL}}/api/v1/auth/confirm-register",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"auth",
								"confirm-register"
							]
						}
					},
					"response": []
				},
				{
					"name": "Login",
					"event": [
						{
							"listen": "test",
							"script": {
								"exec": [
									"const response = pm.response.json();\r",
									"\r",
									"// Test for successful status code\r",
									"pm.test(\"Status code is 200\", function () {\r",
									"    pm.expect(pm.response.code).to.equal(200);\r",
									"});\r",
									"\r",
									"// Check if token exists in the response and set it to environment variable\r",
									"pm.test(\"Token is present in response\", function () {\r",
									"    pm.expect(response.data.token).to.exist;\r",
									"    pm.environment.set(\"token\", response.data.token);\r",
									"});\r",
									""
								],
								"type": "text/javascript",
								"packages": {}
							}
						},
						{
							"listen": "prerequest",
							"script": {
								"exec": [
									""
								],
								"type": "text/javascript",
								"packages": {}
							}
						}
					],
					"request": {
						"method": "POST",
						"header": [],
						"body": {
							"mode": "raw",
							"raw": "{\r\n    \"email\": \"devtest01@mailnesia.com\",\r\n    \"password\":\"hello1234\"\r\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "{{baseURL}}/api/v1/auth/login",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"auth",
								"login"
							]
						}
					},
					"response": []
				},
				{
					"name": "reset-password",
					"request": {
						"method": "POST",
						"header": [],
						"body": {
							"mode": "raw",
							"raw": "{\r\n    \"email\": \"devtest01@mailnesia.com\"\r\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "{{baseURL}}/api/v1/auth/reset-password",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"auth",
								"reset-password"
							]
						}
					},
					"response": []
				},
				{
					"name": "confirm_password",
					"request": {
						"method": "POST",
						"header": [],
						"body": {
							"mode": "raw",
							"raw": "{\r\n    \"email\": \"devtest01@mailnesia.com\",\r\n    \"new_password\": \"hello1234\",\r\n    \"otp\":\"310134\"\r\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "http://localhost:3000/api/v1/auth/confirm-reset-password",
							"protocol": "http",
							"host": [
								"localhost"
							],
							"port": "3000",
							"path": [
								"api",
								"v1",
								"auth",
								"confirm-reset-password"
							]
						}
					},
					"response": []
				},
				{
					"name": "Logout",
					"request": {
						"method": "POST",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{token}}",
								"type": "text"
							}
						],
						"body": {
							"mode": "raw",
							"raw": "",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "{{baseURL}}/api/v1/auth/logout",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"auth",
								"logout"
							]
						}
					},
					"response": []
				},
				{
					"name": "info_user",
					"request": {
						"method": "GET",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{token}}",
								"type": "text"
							}
						],
						"url": {
							"raw": "{{baseURL}}/api/v1/users/",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"users",
								""
							]
						}
					},
					"response": []
				},
				{
					"name": "update",
					"request": {
						"method": "PUT",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{token}}",
								"type": "text"
							}
						],
						"body": {
							"mode": "raw",
							"raw": "{\r\n    \"phone\" : \"0912345609\",\r\n    \"name\" :\"Tran Phuong Khoi\"\r\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "{{baseURL}}/api/v1/users/",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"users",
								""
							]
						}
					},
					"response": []
				},
				{
					"name": "GetAllUser",
					"request": {
						"method": "GET",
						"header": [],
						"url": {
							"raw": ""
						}
					},
					"response": []
				}
			]
		},
		{
			"name": "flights",
			"item": [
				{
					"name": "Admin",
					"item": [
						{
							"name": "CreateNewFlight",
							"request": {
								"method": "POST",
								"header": [
									{
										"key": "Authorization",
										"value": "Bearer {{token}}",
										"type": "text"
									}
								],
								"body": {
									"mode": "raw",
									"raw": "{\r\n  \"airline_id\": 2,\r\n  \"aircraft_id\": 8,\r\n  \"flight_number\": \"VN125\",\r\n  \"departure_airport\": \"SGN\",\r\n  \"arrival_airport\": \"HAN\",\r\n  \"departure_time\": \"2025-07-01T08:00:00Z\",\r\n  \"arrival_time\": \"2025-07-01T10:00:00Z\",\r\n  \"duration_minutes\": 120,\r\n  \"stops_count\": 1,\r\n  \"tax_and_fees\": 200000,\r\n  \"status\": \"scheduled\",\r\n  \"gate\": \"A5\",\r\n  \"terminal\": \"T1\",\r\n  \"distance\": 1160,\r\n  \"flight_classes\": [\r\n    {\r\n      \"class\": \"economy\",\r\n      \"base_price\": 1200000,\r\n      \"available_seats\": 162,\r\n      \"total_seats\": 162\r\n    },\r\n    {\r\n      \"class\": \"business\",\r\n      \"base_price\": 3500000,\r\n      \"available_seats\": 22,\r\n      \"total_seats\": 22\r\n    }\r\n  ]\r\n}"
								},
								"url": {
									"raw": "{{baseURL}}/api/v1/admin/flights/",
									"host": [
										"{{baseURL}}"
									],
									"path": [
										"api",
										"v1",
										"admin",
										"flights",
										""
									]
								}
							},
							"response": []
						},
						{
							"name": "GetAllFlight",
							"request": {
								"method": "GET",
								"header": [
									{
										"key": "Authorization",
										"value": "Bearer {{token}}",
										"type": "text"
									}
								],
								"url": {
									"raw": "http://localhost:3000/api/v1/admin/flights/",
									"protocol": "http",
									"host": [
										"localhost"
									],
									"port": "3000",
									"path": [
										"api",
										"v1",
										"admin",
										"flights",
										""
									]
								}
							},
							"response": []
						},
						{
							"name": "GetFlightAdmin",
							"request": {
								"auth": {
									"type": "bearer",
									"bearer": [
										{
											"key": "token",
											"value": "{{vault:authorization-secret}}",
											"type": "string"
										}
									]
								},
								"method": "GET",
								"header": [],
								"url": {
									"raw": "{{baseURL}}/api/v1/admin/flights/14",
									"host": [
										"{{baseURL}}"
									],
									"path": [
										"api",
										"v1",
										"admin",
										"flights",
										"14"
									]
								}
							},
							"response": []
						},
						{
							"name": "SearchRoundTripAdmin",
							"request": {
								"auth": {
									"type": "bearer",
									"bearer": [
										{
											"key": "token",
											"value": "{{vault:authorization-secret}}",
											"type": "string"
										}
									]
								},
								"method": "POST",
								"header": [],
								"body": {
									"mode": "raw",
									"raw": "{\r\n    \"departure_airport\": \"SGN\",\r\n    \"arrival_airport\": \"HAN\",\r\n    \"departure_date\": \"2025-07-10T00:00:00Z\",\r\n    \"return_date\": \"2025-07-15T00:00:00Z\",\r\n    \"flight_class\": \"economy\", \r\n    \"passengers\": 2,\r\n    \"page\": 1,\r\n    \"limit\": 10,\r\n    \"sort_by\": \"departure_time\",\r\n    \"sort_order\": \"ASC\"\r\n}",
									"options": {
										"raw": {
											"language": "json"
										}
									}
								},
								"url": {
									"raw": "{{baseURL}}/api/v1/admin/flights/search/roundtrip",
									"host": [
										"{{baseURL}}"
									],
									"path": [
										"api",
										"v1",
										"admin",
										"flights",
										"search",
										"roundtrip"
									]
								}
							},
							"response": []
						},
						{
							"name": "CreateFlightClassForFlight",
							"request": {
								"auth": {
									"type": "bearer",
									"bearer": [
										{
											"key": "token",
											"value": "{{vault:authorization-secret}}",
											"type": "string"
										}
									]
								},
								"method": "POST",
								"header": [],
								"url": {
									"raw": "{{baseURL}}/api/v1/admin/flights/48/classes",
									"host": [
										"{{baseURL}}"
									],
									"path": [
										"api",
										"v1",
										"admin",
										"flights",
										"48",
										"classes"
									]
								}
							},
							"response": []
						},
						{
							"name": "SearchFlightAdmin",
							"request": {
								"method": "POST",
								"header": [],
								"body": {
									"mode": "raw",
									"raw": "{\r\n  \"departure_airport\": \"SGN\",\r\n  \"arrival_airport\": \"HAN\",\r\n  \"departure_date\": \"2025-07-01T00:00:00Z\",\r\n  \"arrival_date\": \"2025-07-01T00:00:00Z\",\r\n  \"flight_class\": \"economy\",\r\n  \"max_stops\": 0,\r\n  \"page\": 1,\r\n  \"limit\": 10,\r\n  \"sort_by\": \"departure_time\",\r\n  \"sort_order\": \"ASC\"\r\n}"
								},
								"url": {
									"raw": "{{baseURL}}/api/admin/v1/flights/search",
									"host": [
										"{{baseURL}}"
									],
									"path": [
										"api",
										"admin",
										"v1",
										"flights",
										"search"
									]
								}
							},
							"response": []
						},
						{
							"name": "GetFareClass",
							"request": {
								"auth": {
									"type": "bearer",
									"bearer": [
										{
											"key": "token",
											"value": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NTQ2NjYzNjEsImlhdCI6MTc1NDU3OTk2MSwicm9sZSI6InthZG1pbn0iLCJ1c2VyX2lkIjoiNyJ9.j2NuCmN1E_i1XaRacq1OIlsSH9yeABqn8QFOBGG5amU",
											"type": "string"
										}
									]
								},
								"method": "GET",
								"header": [],
								"url": {
									"raw": "{{baseURL}}/api/v1/admin/flights/fareclasses/53",
									"host": [
										"{{baseURL}}"
									],
									"path": [
										"api",
										"v1",
										"admin",
										"flights",
										"fareclasses",
										"53"
									]
								}
							},
							"response": []
						},
						{
							"name": "GetByDate",
							"request": {
								"auth": {
									"type": "bearer",
									"bearer": [
										{
											"key": "token",
											"value": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NTQ2NjYzNjEsImlhdCI6MTc1NDU3OTk2MSwicm9sZSI6InthZG1pbn0iLCJ1c2VyX2lkIjoiNyJ9.j2NuCmN1E_i1XaRacq1OIlsSH9yeABqn8QFOBGG5amU",
											"type": "string"
										}
									]
								},
								"method": "POST",
								"header": [],
								"body": {
									"mode": "raw",
									"raw": "{\r\n  \"date\": \"01/08/2025\",\r\n  \"page\": 1,\r\n  \"limit\": 10,\r\n  \"status\": \"\",       \r\n  \"sort_by\": \"departure_time\",\r\n  \"sort_order\": \"ASC\"\r\n}",
									"options": {
										"raw": {
											"language": "json"
										}
									}
								},
								"url": {
									"raw": "{{baseURL}}/api/v1/admin/flights/search/date",
									"host": [
										"{{baseURL}}"
									],
									"path": [
										"api",
										"v1",
										"admin",
										"flights",
										"search",
										"date"
									]
								}
							},
							"response": []
						},
						{
							"name": "UpdateFlightTime",
							"request": {
								"method": "GET",
								"header": []
							},
							"response": []
						},
						{
							"name": "SendEmailDelay",
							"request": {
								"method": "GET",
								"header": []
							},
							"response": []
						}
					]
				},
				{
					"name": "GetFlightByIDUser",
					"request": {
						"method": "GET",
						"header": [],
						"url": {
							"raw": "{{baseURL}}/api/v1/flights/61",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"flights",
								"61"
							]
						}
					},
					"response": []
				},
				{
					"name": "SearchFlight",
					"event": [
						{
							"listen": "test",
							"script": {
								"exec": [
									"var template = `\r",
									"<style type=\"text/css\">\r",
									"    .tftable {font-size:14px;color:#333333;width:100%;border-width: 1px;border-color: #87ceeb;border-collapse: collapse;}\r",
									"    .tftable th {font-size:18px;background-color:#87ceeb;border-width: 1px;padding: 8px;border-style: solid;border-color: #87ceeb;text-align:left;}\r",
									"    .tftable tr {background-color:#ffffff;}\r",
									"    .tftable td {font-size:14px;border-width: 1px;padding: 8px;border-style: solid;border-color: #87ceeb;}\r",
									"    .tftable tr:hover {background-color:#e0ffff;}\r",
									"</style>\r",
									"\r",
									"<table class=\"tftable\" border=\"1\">\r",
									"    <tr>\r",
									"        <th>Flight ID</th>\r",
									"        <th>Flight Number</th>\r",
									"        <th>Airline Name</th>\r",
									"        <th>Departure Airport</th>\r",
									"        <th>Arrival Airport</th>\r",
									"        <th>Departure Time</th>\r",
									"        <th>Arrival Time</th>\r",
									"        <th>Duration (Minutes)</th>\r",
									"        <th>Stops Count</th>\r",
									"        <th>Grand Total</th>\r",
									"        <th>Currency</th>\r",
									"    </tr>\r",
									"    \r",
									"    {{#each response.data.search_results}}\r",
									"        <tr>\r",
									"            <td>{{flight_id}}</td>\r",
									"            <td>{{flight_number}}</td>\r",
									"            <td>{{airline_name}}</td>\r",
									"            <td>{{departure_airport}}</td>\r",
									"            <td>{{arrival_airport}}</td>\r",
									"            <td>{{departure_time}}</td>\r",
									"            <td>{{arrival_time}}</td>\r",
									"            <td>{{duration_minutes}}</td>\r",
									"            <td>{{stops_count}}</td>\r",
									"            <td>{{pricing.grand_total}}</td>\r",
									"            <td>{{pricing.currency}}</td>\r",
									"        </tr>\r",
									"    {{/each}}\r",
									"</table>\r",
									"`;\r",
									"\r",
									"function constructVisualizerPayload() {\r",
									"    return {response: pm.response.json()};\r",
									"}\r",
									"\r",
									"pm.visualizer.set(template, constructVisualizerPayload());"
								],
								"type": "text/javascript",
								"packages": {}
							}
						},
						{
							"listen": "prerequest",
							"script": {
								"exec": [
									""
								],
								"type": "text/javascript",
								"packages": {}
							}
						}
					],
					"protocolProfileBehavior": {
						"protocolVersion": "auto"
					},
					"request": {
						"method": "POST",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{token}}",
								"type": "text",
								"disabled": true
							}
						],
						"body": {
							"mode": "raw",
							"raw": "{\r\n    \"departure_airport_code\": \"SGN\",\r\n    \"arrival_airport_code\": \"HAN\",\r\n    \"departure_date\": \"04/08/2025\",\r\n    \"airline_ids\": [],\r\n    \"flight_class\": \"all\",\r\n    \"passenger\": {\r\n        \"adults\": 1,\r\n        \"children\":0,\r\n        \"infant\": 0\r\n\r\n    },\r\n    \"page\": 1,\r\n    \"limit\": 50,\r\n    \"sort_by\": \"price\",\r\n    \"sort_order\": \"asc\"\r\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "{{baseURL}}/api/v1/flights/search",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"flights",
								"search"
							]
						}
					},
					"response": []
				},
				{
					"name": "RoundTripSearch",
					"request": {
						"method": "POST",
						"header": [],
						"body": {
							"mode": "raw",
							"raw": "{\r\n    \"departure_airport_code\": \"HAN\",\r\n    \"arrival_airport_code\": \"SGN\",\r\n    \"departure_date\": \"01/08/2025\",\r\n    \"return_date\": \"04/08/2025\",\r\n    \"airline_ids\": [2],\r\n    \"flight_class\": \"all\",\r\n    \"passengers\": {\r\n        \"adults\": 1\r\n    },\r\n    \"page\": 1,\r\n    \"limit\": 50,\r\n    \"sort_by\": \"price\",\r\n    \"sort_order\": \"asc\"\r\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "{{baseURL}}/api/v1/flights/search/roundtrip",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"flights",
								"search",
								"roundtrip"
							]
						}
					},
					"response": []
				},
				{
					"name": "UpdateStatus",
					"request": {
						"auth": {
							"type": "bearer",
							"bearer": [
								{
									"key": "token",
									"value": "{{vault:authorization-secret}}",
									"type": "string"
								}
							]
						},
						"method": "PATCH",
						"header": [],
						"body": {
							"mode": "raw",
							"raw": "{\r\n    \"status\": \"delayed\",\r\n    \"reason\": \"Bad weather conditions\"\r\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "{{baseURL}}/api/v1/flights/7/status",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"flights",
								"7",
								"status"
							]
						}
					},
					"response": []
				},
				{
					"name": "UpdateFlight",
					"request": {
						"auth": {
							"type": "bearer",
							"bearer": [
								{
									"key": "token",
									"value": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NTM2MDQ4NDUsImlhdCI6MTc1MzUxODQ0NSwicm9sZSI6InthZG1pbn0iLCJ1c2VyX2lkIjoiNyJ9.9beDV-6r55k9eeRo5WI5R1g_U5gJvvQSXA5hpYE8Bwc",
									"type": "string"
								}
							]
						},
						"method": "PUT",
						"header": [],
						"body": {
							"mode": "raw",
							"raw": "{\r\n    \"airline_id\": 2,\r\n    \"flight_number\": \"VN874\",\r\n    \"departure_airport\": \"Sân Bay Tân Sơn Nhất\",\r\n    \"arrival_airport\": \"Sân Bay Đà Nẵng\",\r\n    \"departure_time\": \"28/07/2025 16:00\",\r\n    \"arrival_time\": \"28/07/2025 18:00\",\r\n    \"duration_minutes\": 120,\r\n    \"stops_count\": 0,\r\n    \"tax_and_fees\": 250000,\r\n    \"status\": \"scheduled\",\r\n    \"distance\": 1166,\r\n    \"currency\": \"VND\",\r\n    \"departure_code\": \"SGN\",\r\n    \"arrival_airport_code\": \"DAD\"\r\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "{{baseURL}}/api/v1/admin/flights/48",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"admin",
								"flights",
								"48"
							]
						}
					},
					"response": []
				},
				{
					"name": "GetByStatus",
					"request": {
						"method": "GET",
						"header": [],
						"url": {
							"raw": ""
						}
					},
					"response": []
				},
				{
					"name": "GetByAirline",
					"request": {
						"method": "GET",
						"header": [],
						"url": {
							"raw": ""
						}
					},
					"response": []
				}
			]
		},
		{
			"name": "Booking",
			"item": [
				{
					"name": "CreateBooking",
					"request": {
						"method": "POST",
						"header": [
							{
								"key": "Accept",
								"value": "application/json"
							},
							{
								"key": "Authorization",
								"value": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NTY3NTk2MzcsImlhdCI6MTc1NjY3MzIzNywicm9sZSI6Int1c2VyfSIsInVzZXJfaWQiOiIxNSJ9.oXJnux9mzjVNKVrBE-p4d86uTNDVyWrjavumsZxwvlg"
							},
							{
								"key": "Content-Type",
								"value": "application/json"
							}
						],
						"body": {
							"mode": "raw",
							"raw": "{\r\n    \"flight_id\": 63,\r\n    \"contact_name\": \"Tran Phuong Khoi\",\r\n    \"contact_email\": \"devtest01@mailnesia.com\",\r\n    \"contact_phone\": \"0945678909\",\r\n    \"contact_address\": \"1 836 000\",\r\n    \"note\": \"1 836 000\",\r\n    \"total_price\": 1836000,\r\n    \"details\": [\r\n        {\r\n            \"passenger_age\": 35,\r\n            \"passenger_gender\": \"male\",\r\n            \"flight_class_id\": 65,\r\n            \"price\": 816000,\r\n            \"last_name\": \"Nguyen Van\",\r\n            \"first_name\": \"Anh\",\r\n            \"date_of_birth\": \"15/05/1990\",\r\n            \"id_type\": \"id_card\",\r\n            \"id_number\": \"001099001234\",\r\n            \"expiry_date\": \"15/05/2030\",\r\n            \"issuing_country\": \"VN\",\r\n            \"nationality\": \"VN\"\r\n        }\r\n    ],\r\n    \"ancillaries\": [\r\n        {\r\n            \"type\": \"baggage\",\r\n            \"description\": \" Hành lý ký gửi thêm 10kg - Hành khách 1: Nguyen Van, Anh\",\r\n            \"quantity\": 10,\r\n            \"price\": 190000\r\n        },\r\n        {\r\n            \"type\": \"service\",\r\n            \"description\": \"Dịch vụ chọn chỗ ngồi - 1 hành khách\",\r\n            \"quantity\": 1,\r\n            \"price\": 150000\r\n        },\r\n        {\r\n            \"type\": \"service\",\r\n            \"description\": \"Dịch vụ WiFi trên chuyến bay - 1 hành khách\",\r\n            \"quantity\": 1,\r\n            \"price\": 80000\r\n        },\r\n        {\r\n            \"type\": \"service\",\r\n            \"description\": \"Lên máy bay ưu tiên - 1 hành khách\",\r\n            \"quantity\": 1,\r\n            \"price\": 100000\r\n        },\r\n        {\r\n            \"type\": \"service\",\r\n            \"description\": \"Nâng cấp suất ăn - 1 hành khách\",\r\n            \"quantity\": 1,\r\n            \"price\": 200000\r\n        },\r\n        {\r\n            \"type\": \"service\",\r\n            \"description\": \"Phòng chờ VIP sân bay - 1 hành khách\",\r\n            \"quantity\": 1,\r\n            \"price\": 300000\r\n        }\r\n    ]\r\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "{{baseURL}}/api/v1/booking",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"booking"
							]
						}
					},
					"response": []
				},
				{
					"name": "SendBookingEmail",
					"request": {
						"method": "POST",
						"header": [],
						"url": {
							"raw": "{{baseURL}}/api/v1/send-email?booking_id=131",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"send-email"
							],
							"query": [
								{
									"key": "booking_id",
									"value": "131"
								}
							]
						}
					},
					"response": []
				},
				{
					"name": "GetBookingByID",
					"request": {
						"method": "GET",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{token}}",
								"type": "text"
							}
						],
						"url": {
							"raw": "{{baseURL}}/api/v1/booking/135",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"booking",
								"135"
							]
						}
					},
					"response": []
				},
				{
					"name": "GetBookingByUserID",
					"request": {
						"method": "GET",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{token}}",
								"type": "text"
							}
						],
						"url": {
							"raw": "{{baseURL}}/api/v1/booking/user/15",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"booking",
								"user",
								"15"
							]
						}
					},
					"response": []
				}
			]
		},
		{
			"name": "TestRaceCondition",
			"item": [
				{
					"name": "Test1",
					"request": {
						"auth": {
							"type": "bearer",
							"bearer": [
								{
									"key": "token",
									"value": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NTYxNjk4NjAsImlhdCI6MTc1NjA4MzQ2MCwicm9sZSI6Int1c2VyfSIsInVzZXJfaWQiOiI4In0.-UAZ3G16ENcuRJZqcGV860HWXGRvfRhOSr_ymMqj2d0",
									"type": "string"
								}
							]
						},
						"method": "POST",
						"header": [],
						"body": {
							"mode": "raw",
							"raw": "{\r\n  \"flight_id\": 274,\r\n  \"contact_email\": \"user@example.com\",\r\n  \"contact_phone\": \"0912345678\",\r\n  \"contact_name\" : \"VI Khang\",\r\n  \"contact_address\": \"123 Example Street, District 1, HCM City\",\r\n  \"note\": \"Không hút thuốc\",\r\n  \"total_price\": 2950000,\r\n  \"details\": [\r\n    {\r\n      \"passenger_age\": 35,\r\n      \"passenger_gender\": \"male\",\r\n      \"flight_class_id\": 347,\r\n\r\n      \"price\": 2500000,\r\n      \"last_name\": \"Nguyễn\",\r\n      \"first_name\": \"Văn A\",\r\n      \"date_of_birth\": \"15/05/1988\",\r\n      \"id_type\": \"id_card\",\r\n      \"id_number\": \"123456789\",\r\n      \"expiry_date\": \"20/10/2028\",\r\n      \"issuing_country\": \"Vietnam\",\r\n      \"nationality\": \"Vietnam\"\r\n    }\r\n  ],\r\n  \"ancillaries\": [\r\n    {\r\n      \"type\": \"baggage\",\r\n      \"description\": \"Hành lý ký gửi 20kg\",\r\n      \"quantity\": 1,\r\n      \"price\": 300000\r\n    },\r\n    {\r\n      \"type\": \"meal\",\r\n      \"description\": \"Suất ăn đặc biệt\",\r\n      \"quantity\": 1,\r\n      \"price\": 150000\r\n    }\r\n  ]\r\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "{{baseURL}}/api/v1/booking",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"booking"
							]
						}
					},
					"response": []
				},
				{
					"name": "Test2",
					"request": {
						"auth": {
							"type": "bearer",
							"bearer": [
								{
									"key": "token",
									"value": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NTYxNjk4OTgsImlhdCI6MTc1NjA4MzQ5OCwicm9sZSI6Int1c2VyfSIsInVzZXJfaWQiOiI5In0.LjdFfqEvJOOOpV7-zyV0TzKD0BnsCxWTDyhU-sMmbYE",
									"type": "string"
								}
							]
						},
						"method": "POST",
						"header": [],
						"body": {
							"mode": "raw",
							"raw": "{\r\n  \"flight_id\": 274,\r\n  \"contact_email\": \"user@example.com\",\r\n  \"contact_phone\": \"0912345678\",\r\n  \"contact_name\" : \"VI Khang\",\r\n  \"contact_address\": \"123 Example Street, District 1, HCM City\",\r\n  \"note\": \"Không hút thuốc\",\r\n  \"total_price\": 2950000,\r\n  \"details\": [\r\n    {\r\n      \"passenger_age\": 35,\r\n      \"passenger_gender\": \"male\",\r\n      \"flight_class_id\": 347,\r\n\r\n      \"price\": 2500000,\r\n      \"last_name\": \"Nguyễn\",\r\n      \"first_name\": \"Văn A\",\r\n      \"date_of_birth\": \"15/05/1988\",\r\n      \"id_type\": \"id_card\",\r\n      \"id_number\": \"123456789\",\r\n      \"expiry_date\": \"20/10/2028\",\r\n      \"issuing_country\": \"Vietnam\",\r\n      \"nationality\": \"Vietnam\"\r\n    }\r\n  ],\r\n  \"ancillaries\": [\r\n    {\r\n      \"type\": \"baggage\",\r\n      \"description\": \"Hành lý ký gửi 20kg\",\r\n      \"quantity\": 1,\r\n      \"price\": 300000\r\n    },\r\n    {\r\n      \"type\": \"meal\",\r\n      \"description\": \"Suất ăn đặc biệt\",\r\n      \"quantity\": 1,\r\n      \"price\": 150000\r\n    }\r\n  ]\r\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "{{baseURL}}/api/v1/booking",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"booking"
							]
						}
					},
					"response": []
				}
			]
		},
		{
			"name": "Payment",
			"item": [
				{
					"name": "Momo QR Pay",
					"event": [
						{
							"listen": "test",
							"script": {
								"exec": [
									"var template = `\r",
									"<style type=\"text/css\">\r",
									"    .tftable {font-size:14px;color:#333333;width:100%;border-width: 1px;border-color: #87ceeb;border-collapse: collapse;}\r",
									"    .tftable th {font-size:18px;background-color:#87ceeb;border-width: 1px;padding: 8px;border-style: solid;border-color: #87ceeb;text-align:left;}\r",
									"    .tftable tr {background-color:#ffffff;}\r",
									"    .tftable td {font-size:14px;border-width: 1px;padding: 8px;border-style: solid;border-color: #87ceeb;}\r",
									"    .tftable tr:hover {background-color:#e0ffff;}\r",
									"</style>\r",
									"\r",
									"<table class=\"tftable\" border=\"1\">\r",
									"    <tr>\r",
									"        <th>Payment ID</th>\r",
									"        <th>Amount</th>\r",
									"        <th>Booking ID</th>\r",
									"        <th>Paid At</th>\r",
									"        <th>Payment Method</th>\r",
									"        <th>Status</th>\r",
									"        <th>Transaction ID</th>\r",
									"        <th>Momo Response Message</th>\r",
									"        <th>Response Time</th>\r",
									"        <th>Result Code</th>\r",
									"    </tr>\r",
									"    \r",
									"    <tr>\r",
									"        <td>{{response.data.createdPayment.payment_id}}</td>\r",
									"        <td>{{response.data.createdPayment.amount}}</td>\r",
									"        <td>{{response.data.createdPayment.booking_id}}</td>\r",
									"        <td>{{response.data.createdPayment.paid_at}}</td>\r",
									"        <td>{{response.data.createdPayment.payment_method}}</td>\r",
									"        <td>{{response.data.createdPayment.status}}</td>\r",
									"        <td>{{response.data.createdPayment.transaction_id}}</td>\r",
									"        <td>{{response.data.momoResponse.message}}</td>\r",
									"        <td>{{response.data.momoResponse.responseTime}}</td>\r",
									"        <td>{{response.data.momoResponse.resultCode}}</td>\r",
									"    </tr>\r",
									"</table>\r",
									"`;\r",
									"\r",
									"function constructVisualizerPayload() {\r",
									"    return {response: pm.response.json()};\r",
									"}\r",
									"\r",
									"pm.visualizer.set(template, constructVisualizerPayload());"
								],
								"type": "text/javascript",
								"packages": {}
							}
						},
						{
							"listen": "prerequest",
							"script": {
								"exec": [],
								"type": "text/javascript"
							}
						}
					],
					"request": {
						"method": "POST",
						"header": [],
						"body": {
							"mode": "raw",
							"raw": "{\r\n    \"booking_id\": \"100\",\r\n    \"partnerCode\": \"MOMO\",\r\n    \"accessKey\": \"F8BBA842ECF85\",\r\n    \"requestId\": \"123456\",\r\n    \"amount\": \"195000\",\r\n    \"orderId\": \"123456\",\r\n    \"orderInfo\": \"Thanh toan ve may bay FlyJourney\",\r\n    \"redirectUrl\": \"http://localhost:3000/api/v1/payment/momo/success\",\r\n    \"ipnUrl\": \"https://e4126c7f6e45.ngrok-free.app/api/v1/payment/momo/callback\",\r\n    \"extraData\": \"\",\r\n    \"requestType\": \"captureWallet\"\r\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "http://localhost:3000/api/v1/payment/momo",
							"protocol": "http",
							"host": [
								"localhost"
							],
							"port": "3000",
							"path": [
								"api",
								"v1",
								"payment",
								"momo"
							]
						}
					},
					"response": []
				},
				{
					"name": "MomoCallback",
					"request": {
						"method": "POST",
						"header": [],
						"body": {
							"mode": "raw",
							"raw": "{\r\n    \"partnerCode\": \"MOMO\",\r\n    \"orderId\": \"123456786\",\r\n    \"requestId\": \"123456788\",\r\n    \"amount\": 100000,\r\n    \"orderInfo\": \"Thanh toan ve may bay FlyJourney\",\r\n    \"orderType\": \"momo_wallet\",\r\n    \"transId\": 4563938693,\r\n    \"resultCode\": 0,\r\n    \"message\": \"Successful.\",\r\n    \"payType\": \"qr\",\r\n    \"responseTime\": 1755451560563,\r\n    \"extraData\": \"\",\r\n    \"signature\": \"cdffc7711692f4a9ebc9e2db41f8fa887f668423df95913d63c0a07488d6fca6\"\r\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "http://localhost:3000/api/v1/payment/momo/callback",
							"protocol": "http",
							"host": [
								"localhost"
							],
							"port": "3000",
							"path": [
								"api",
								"v1",
								"payment",
								"momo",
								"callback"
							]
						}
					},
					"response": []
				}
			]
		},
		{
			"name": "Checkin-Online",
			"item": [
				{
					"name": "ValidateCheckin",
					"request": {
						"method": "POST",
						"header": [
							{
								"key": "Accept",
								"value": "application/json"
							},
							{
								"key": "Authorization",
								"value": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NTY3NTk2MzcsImlhdCI6MTc1NjY3MzIzNywicm9sZSI6Int1c2VyfSIsInVzZXJfaWQiOiIxNSJ9.oXJnux9mzjVNKVrBE-p4d86uTNDVyWrjavumsZxwvlg"
							},
							{
								"key": "Content-Type",
								"value": "application/json"
							}
						],
						"body": {
							"mode": "raw",
							"raw": "{\r\n    \"pnr_code\" :\"HC2036\",\r\n    \"email\" : \"devtest01@mailnesia.com\",\r\n    \"full_name\" : \"Trần Phương Khôi\"\r\n}"
						},
						"url": {
							"raw": "{{baseURL}}/api/v1/checkin/validate",
							"host": [
								"{{baseURL}}"
							],
							"path": [
								"api",
								"v1",
								"checkin",
								"validate"
							]
						}
					},
					"response": []
				},
				{
					"name": "GetSeatMap",
					"request": {
						"method": "GET",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{token}}",
								"type": "text"
							}
						],
						"url": {
							"raw": "http://localhost:3000/api/v1/checkin/318",
							"protocol": "http",
							"host": [
								"localhost"
							],
							"port": "3000",
							"path": [
								"api",
								"v1",
								"checkin",
								"318"
							]
						}
					},
					"response": []
				},
				{
					"name": "CreateCheckin",
					"request": {
						"method": "GET",
						"header": []
					},
					"response": []
				}
			]
		},
		{
			"name": "New Request",
			"request": {
				"method": "POST",
				"header": [
					{
						"key": "Content-Type",
						"value": "application/json"
					}
				],
				"body": {
					"mode": "raw",
					"raw": "{\r\n    \"departure_airport_code\": \"HAN\",\r\n    \"arrival_airport_code\": \"SGN\",\r\n    \"departure_date\": \"12/08/2025\",\r\n    \"return_date\": \"14/08/2025\",\r\n    \"flight_class\": \"all\",\r\n    \"passengers\": {\r\n        \"adults\": 2\r\n    },\r\n    \"page\": 1,\r\n    \"limit\": 50,\r\n    \"sort_by\": \"price\",\r\n    \"sort_order\": \"asc\",\r\n    \"passenger\": {\r\n        \"adults\": 2\r\n    }\r\n}",
					"options": {
						"raw": {
							"language": "json"
						}
					}
				},
				"url": {
					"raw": "http://localhost:3000/api/v1/flights/search/roundtrip",
					"protocol": "http",
					"host": [
						"localhost"
					],
					"port": "3000",
					"path": [
						"api",
						"v1",
						"flights",
						"search",
						"roundtrip"
					]
				}
			},
			"response": []
		}
	],
	"variable": [
		{
			"key": "baseURL",
			"value": "http://localhost:3000",
			"type": "default"
		}
	]
}
