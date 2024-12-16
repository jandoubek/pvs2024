import React, { useState, useEffect, useRef } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import {
  Button,
  Box,
  Typography,
  Alert,
  Collapse,
  Container,
  Paper,
} from "@mui/material";
import { LocalizationProvider } from "@mui/x-date-pickers";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { DateTimePicker } from "@mui/x-date-pickers/DateTimePicker";

import StationSelector from "./StationSelector";

const API_BASE_URL = "http://localhost:52773/csp/user";

const SearchForm = () => {
  const navigate = useNavigate();
  const [data, setData] = useState(() => {
    const cached = localStorage.getItem('stations');
    return cached ? JSON.parse(cached) : null;
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [fromStation, setFromStation] = useState(null);
  const [toStation, setToStation] = useState(null);
  const [dateTime, setDateTime] = useState(null);
  const [validationMessage, setValidationMessage] = useState("");
  const [showAlert, setShowAlert] = useState(false);

  useEffect(() => {
    if (!data) {
      loadStations();
    }
  }, [data]);

  const loadStations = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await axios.get(`${API_BASE_URL}/stations`);
      setData(response.data);
      localStorage.setItem('stations', JSON.stringify(response.data));
    } catch (err) {
      setError(err.response?.data?.error || "Error fetching data from the API");
      console.error("API Error:", err.response?.data || err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    let timer;
    if (showAlert) {
      timer = setTimeout(() => {
        setShowAlert(false);
      }, 3000);
    }
    return () => clearTimeout(timer);
  }, [showAlert]);

  const validateForm = () => {
    const missingFields = [];
    
    if (!fromStation) {
      missingFields.push("místo odjezdu");
    }
    if (!toStation) {
      missingFields.push("místo příjezdu");
    }
    if (!dateTime) {
      missingFields.push("datum a čas odjezdu");
    }

    if (missingFields.length > 0) {
      setValidationMessage(`Prosím vyplňte: ${missingFields.join(", ")}`);
      setShowAlert(true);
      return false;
    }
    return true;
  };

  const handleSearch = async () => {
    if (validateForm()) {
      try {
        const params = {
          fromStation: fromStation.id,
          toStation: toStation.id,
          dateTime: dateTime.format("YYYY-MM-DD HH:mm:ss")
        };
        
        const response = await axios.get(`${API_BASE_URL}/trips`, {
          params,
          withCredentials: true,
          headers: {
            'Content-Type': 'application/json',
          }
        });
        
        navigate("/results", {
          state: {
            trips: response.data,
            searchParams: {
              fromStation,
              toStation,
              dateTime: dateTime.format("DD.MM.YYYY HH:mm"),
            }
          }
        });
      } catch(err) {
        console.error("API Error:", err.response?.data || err.message);
        setError("Nepodařilo se načíst spoje. Zkuste to prosím později.");
        setShowAlert(true);
      }
    }
  };

  const handleSwapStations = () => {
    setFromStation(toStation);
    setToStation(fromStation);
  };

  if (loading) return (
    <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '100vh' }}>
      <Typography>Loading...</Typography>
    </Box>
  );
  
  if (error) return (
    <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '100vh' }}>
      <Typography color="error">{error}</Typography>
    </Box>
  );

  return (
    <LocalizationProvider dateAdapter={AdapterDayjs}>
      <Box
        sx={{
          minHeight: '100vh',
          display: 'flex',
          alignItems: 'center',
          backgroundColor: '#f5f5f5',
        }}
      >
        <Container maxWidth="sm">
          <Paper 
            elevation={3}
            sx={{
              padding: 4,
              borderRadius: 2,
            }}
          >
            <Typography 
              variant="h4" 
              gutterBottom 
              align="center"
              sx={{
                mb: 4,
                fontWeight: 500,
                color: 'primary.main',
              }}
            >
              Vyhledání spojení
            </Typography>

            <Collapse in={showAlert}>
              <Alert 
                severity="warning" 
                sx={{ mb: 2 }}
                onClose={() => setShowAlert(false)}
              >
                {validationMessage}
              </Alert>
            </Collapse>

            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 3 }}>
              <StationSelector
                fromStation={fromStation}
                toStation={toStation}
                onFromStationChange={(e, newValue) => setFromStation(newValue)}
                onToStationChange={(e, newValue) => setToStation(newValue)}
                onSwapStations={handleSwapStations}
                stations={data?.stations || []}
              />

              <DateTimePicker
                label="Vyberte datum a čas odjezdu"
                value={dateTime}
                onChange={(newDateTime) => setDateTime(newDateTime)}
                ampm={false}
                format="DD.MM.YYYY HH:mm"
                sx={{ width: '100%' }}
              />

              <Button
                variant="contained"
                color="primary"
                onClick={handleSearch}
                fullWidth
                size="large"
                sx={{ 
                  mt: 2,
                  py: 1.5,
                  fontSize: '1.1rem',
                }}
              >
                Hledat
              </Button>
            </Box>
          </Paper>
        </Container>
      </Box>
    </LocalizationProvider>
  );
};

export default SearchForm;