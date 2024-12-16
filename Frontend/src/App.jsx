import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import SearchForm from "./components/SearchForm";
import ResultsPage from "./components/ResultsPage";
import Header from "./components/Header";
import { Box, Container } from "@mui/material";

const App = () => {
  return (
    <Router>
      <Box sx={{ display: 'flex', flexDirection: 'column', height: '100vh' }}>
        <Header />
        <Box
          component="main"
          sx={{
            flexGrow: 1,
            pt: { xs: 8, sm: 9 }, // Add padding top to account for fixed AppBar
            overflow: 'auto'
          }}
        >
          <Container sx={{ maxWidth: 1200, height: '100%' }}>
            <Routes>
              <Route path="/" element={<SearchForm />} />
              <Route path="/results" element={<ResultsPage />} />
            </Routes>
          </Container>
        </Box>
      </Box>
    </Router>
  );
};

export default App;