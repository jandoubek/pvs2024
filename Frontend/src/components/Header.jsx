import React, { useState } from 'react';
import { Box, AppBar, Toolbar, Typography, IconButton, Tooltip } from "@mui/material";
import HelpIcon from '@mui/icons-material/Help';
import LightModeIcon from '@mui/icons-material/LightMode';
import DarkModeIcon from '@mui/icons-material/DarkMode';

const Header = () => {
    const [isDarkMode, setIsDarkMode] = useState(false);

    const handleThemeToggle = () => {
        setIsDarkMode(!isDarkMode);
    };

    return (
        <AppBar position="fixed">
            <Toolbar>
                <Box sx={{ flexGrow: 1, display: 'flex', alignItems: 'center' }}>
                    <Typography 
                        component="span"
                        sx={{ 
                            fontSize: '30px',  
                            fontWeight: 600,
                            fontStyle: 'oblique'
                        }}
                    >
                        Jízdní
                    </Typography>
                    <Typography 
                        component="span"
                        sx={{ 
                            fontSize: '28px',  
                            fontWeight: 600,   
                            marginLeft: '4px',
                            fontStyle: 'oblique'
                        }}
                    >
                        řády
                    </Typography>
                </Box>
                <Box sx={{ display: 'flex', gap: 1, alignItems: 'center' }}>
                    <Tooltip title={isDarkMode ? "Změnit do světlého módu" : "Změnit do tmavého módu"}>
                        <IconButton 
                            color="inherit" 
                            onClick={handleThemeToggle}
                            size="large"
                        >
                            {isDarkMode ? <LightModeIcon /> : <DarkModeIcon />}
                        </IconButton>
                    </Tooltip>
                    <Tooltip title="Nápověda">
                        <IconButton 
                            color="inherit"
                            size="large"
                        >
                            <HelpIcon />
                        </IconButton>
                    </Tooltip>
                </Box>
            </Toolbar>
        </AppBar>
    );
};

export default Header;