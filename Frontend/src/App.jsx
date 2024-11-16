import React, { useState, useEffect } from "react";
import axios from "axios";
import {
  Autocomplete,
  TextField,
  Button,
  Box,
  Typography,
} from "@mui/material";
import { LocalizationProvider } from "@mui/x-date-pickers";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { DateTimePicker } from "@mui/x-date-pickers/DateTimePicker";
import dayjs from "dayjs";

const API_BASE_URL = "http://localhost:52773/csp/user";

const App = () => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [fromStation, setFromStation] = useState(null);
  const [toStation, setToStation] = useState(null);
  const [dateTime, setDateTime] = useState(dayjs());
  const [searchResult, setSearchResult] = useState("");

  useEffect(() => {
    loadStations();
  }, []);

  const loadStations = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await axios.get(`${API_BASE_URL}/data`);
      setData(response.data);
    } catch (err) {
      setError(err.response?.data?.error || "Error fetching data from the API");
      console.error("API Error:", err.response?.data || err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = () => {
    if (fromStation && toStation && dateTime) {
      setSearchResult(
        `Hledám spoj z: ${fromStation.label} do: ${
          toStation.label
        } dne: ${dateTime.format("DD.MM.YYYY")} v čase: ${dateTime.format(
          "HH:mm"
        )}`
      );
    } else {
      setSearchResult("Prosím vyberte místo odjezdu, příjezdu a čas odjezdu.");
    }
  };

  if (loading) return <Typography>Loading...</Typography>;
  if (error) return <Typography color="error">{error}</Typography>;

  return (
    <LocalizationProvider dateAdapter={AdapterDayjs}>
      <Box
        sx={{
          display: "flex",
          flexDirection: "column",
          gap: 2,
          maxWidth: 400,
          margin: "auto",
          padding: 2,
        }}
      >
        <Autocomplete
          options={data?.stations || []}
          value={fromStation}
          onChange={(event, newValue) => setFromStation(newValue)}
          renderInput={(params) => <TextField {...params} label="Odkud" />}
        />

        <Autocomplete
          options={data?.stations || []}
          value={toStation}
          onChange={(event, newValue) => setToStation(newValue)}
          renderInput={(params) => <TextField {...params} label="Kam" />}
        />

        <DateTimePicker
          label="Vyberte datum a čas odjezdu"
          value={dateTime}
          onChange={(newDateTime) => setDateTime(newDateTime)}
          ampm={false} // Use 24-hour format
          format="DD.MM.YYYY HH:mm"
        />

        <Button
          variant="contained"
          color="primary"
          onClick={handleSearch}
          sx={{ mt: 2 }}
        >
          Hledat
        </Button>

        {searchResult && (
          <Typography variant="body1" sx={{ mt: 2 }}>
            {searchResult}
          </Typography>
        )}
      </Box>
    </LocalizationProvider>
  );
};

export default App;
