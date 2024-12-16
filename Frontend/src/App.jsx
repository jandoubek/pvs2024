import React from "react";
import { BrowserRouter as Router, Routes, Route, useNavigate } from "react-router-dom";
import SearchForm from "./components/SearchForm";
import ResultsPage from "./components/ResultsPage";
import { Box } from "@mui/material";

const App = () => {
  return (
    <Router>
      <Box sx={{ maxWidth: 1200, margin: "auto", padding: 2 }}>
        <Routes>
          <Route path="/" element={<SearchForm />} />
          <Route path="/results" element={<ResultsPage />} />
        </Routes>
      </Box>
    </Router>
  );
};

export default App;