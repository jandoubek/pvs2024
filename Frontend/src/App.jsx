import React, { useState, useEffect } from "react";
import axios from "axios";
import {
  Button,
  Box,
  Typography,
  IconButton,
} from "@mui/material";
import CloseIcon from "@mui/icons-material/Close";
import { LocalizationProvider } from "@mui/x-date-pickers";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { DateTimePicker } from "@mui/x-date-pickers/DateTimePicker";
import dayjs from "dayjs";
import "./App.css";

import StationSelector from "./components/StationSelector";

const API_BASE_URL = "http://localhost:52773/csp/user";

const App = () => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [fromStation, setFromStation] = useState(null);
  const [toStation, setToStation] = useState(null);
  const [dateTime, setDateTime] = useState(dayjs());
  const [searchResult, setSearchResult] = useState("");
  const [showInfoBox, setShowInfoBox] = useState(false);

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
        `Hledám spoj z: ${fromStation.label} do: ${toStation.label} dne: ${dateTime.format(
          "DD.MM.YYYY"
        )} v čase: ${dateTime.format("HH:mm")}`
      );
      setShowInfoBox(true);
    } else {
      setSearchResult("Prosím vyberte místo odjezdu, příjezdu a čas odjezdu.");
    }
  };

  const handleCloseBox = () => {
    setShowInfoBox(false);
  };

  const handleSwapStations = () => {
    setFromStation(toStation);
    setToStation(fromStation);
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
          maxWidth: 600,
          margin: "auto",
          padding: 2,
        }}
      >
        <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
          <StationSelector
            fromStation={fromStation}
            toStation={toStation}
            onFromStationChange={(e, newValue) => setFromStation(newValue)}
            onToStationChange={(e, newValue) => setToStation(newValue)}
            onSwapStations={handleSwapStations}
            stations={data?.stations || []}
          />
        </Box>

        <DateTimePicker
          label="Vyberte datum a čas odjezdu"
          value={dateTime}
          onChange={(newDateTime) => setDateTime(newDateTime)}
          ampm={false} // 24 format
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

        {showInfoBox && (
          <div className="showInfoBox">
            <IconButton onClick={handleCloseBox} className="closeButton">
              <CloseIcon />
            </IconButton>
            <Typography variant="h4" gutterBottom>
              Výsledek hledání
            </Typography>
            <Typography variant="body1">{searchResult}</Typography>
          </div>
        )}
      </Box>
    </LocalizationProvider>
  );
};

export default App;
