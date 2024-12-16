import React, { useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import {
  Box,
  Typography,
  Button,
  Paper,
  CircularProgress,
} from "@mui/material";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import TripResults from "./TripResults";

const ResultsPage = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const { trips: initialTrips, searchParams } = location.state || {};

  
  const [allTrips, setAllTrips] = useState(initialTrips?.trips || []);
  const [loading, setLoading] = useState(false);
  console.log(allTrips);

  const getNextDayDate = (dateStr) => {
    const parts = dateStr.split('.');
    const date = new Date(parts[2], parts[1] - 1, parts[0]);
    date.setDate(date.getDate() + 1);
    return `${date.getDate().toString().padStart(2, '0')}.${(date.getMonth() + 1).toString().padStart(2, '0')}.${date.getFullYear()}`;
  };

  const handleLoadMore = async () => {
    setLoading(true);
    
    const lastTripDate = allTrips[allTrips.length - 1].Datum;
    const nextDate = getNextDayDate(lastTripDate);

    try {
      const nextDayTrips = allTrips.map(trip => ({
        ...trip,
        Datum: nextDate
      }));

      setAllTrips(prevTrips => [...prevTrips, ...nextDayTrips]);
    } catch (error) {
      console.error("Failed to load more trips:", error);
    } finally {
      setLoading(false);
    }
  };


  if (!initialTrips || !searchParams) {
    return (
      <Box sx={{ textAlign: "center", mt: 4 }}>
        <Typography variant="h5" gutterBottom>
          Nebyly nalezeny žádné výsledky
        </Typography>
        <Button
          startIcon={<ArrowBackIcon />}
          onClick={() => navigate("/")}
          variant="contained"
          sx={{ mt: 2 }}
        >
          Zpět na vyhledávání
        </Button>
      </Box>
    );
  }

  return (
    <Box sx={{ maxWidth: 800, margin: "auto", padding: 2 }}>
      <Button
        startIcon={<ArrowBackIcon />}
        onClick={() => navigate("/")}
        variant="outlined"
        sx={{ mb: 3 }}
      >
        Zpět na vyhledávání
      </Button>

      <Paper 
        sx={{ 
          p: 3, 
          mb: 3,
          textAlign: 'center',
          borderRadius: 2,
          boxShadow: 2
        }}
      >
        <Typography 
          variant="h5" 
          gutterBottom 
          sx={{ 
            fontWeight: 500,
            mb: 3,
            borderBottom: '1px solid',
            borderColor: 'divider',
            pb: 2
          }}
        >
          Výsledky vyhledávání
        </Typography>
        <Box sx={{ 
          display: 'flex', 
          flexDirection: 'column', 
          gap: 1,
          maxWidth: 400,
          mx: 'auto'
        }}>
          <Typography variant="body1" sx={{ color: 'text.secondary' }}>
            Z: {searchParams.fromStation.label}
          </Typography>
          <Typography variant="body1" sx={{ color: 'text.secondary' }}>
            Do: {searchParams.toStation.label}
          </Typography>
          <Typography variant="body1" sx={{ color: 'text.secondary' }}>
            Datum a čas: {searchParams.dateTime}
          </Typography>
        </Box>
      </Paper>

      <TripResults trips={{ trips: allTrips }} />

      <Box sx={{ 
        display: 'flex', 
        justifyContent: 'center', 
        mt: 3 
      }}>
        <Button
          variant="outlined"
          onClick={handleLoadMore}
          disabled={loading}
          sx={{ minWidth: 200 }}
        >
          {loading ? (
            <>
              <CircularProgress size={20} sx={{ mr: 1 }} />
              Načítání...
            </>
          ) : (
            "Načíst další den"
          )}
        </Button>
      </Box>
    </Box>
  );
};

export default ResultsPage;