```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>BMX Race Tracker</title>
    <style>
        * {
            box-sizing: border-box;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            overflow-x: hidden;
        }
        .container {
            min-height: 100vh;
            padding: 10px;
        }
        h1 {
            color: #333;
            text-align: center;
            margin: 10px 0 20px 0;
            font-size: 24px;
        }
        .status-box {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .at-gate {
            border: 3px solid #ff4444;
            background-color: #ffeeee;
        }
        .staging {
            border: 3px solid #ff9944;
            background-color: #fff5ee;
        }
        .status-box h2 {
            margin: 0 0 15px 0;
            color: #333;
            font-size: 20px;
            text-align: center;
        }
        .moto-number {
            font-size: 72px;
            font-weight: bold;
            color: #333;
            text-align: center;
            margin: 20px 0;
            line-height: 1;
        }
        .box-controls {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 10px;
            margin-bottom: 10px;
        }
        .input-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 10px;
        }
        button {
            padding: 15px;
            font-size: 18px;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            background-color: #007bff;
            color: white;
            -webkit-tap-highlight-color: transparent;
        }
        button:active {
            background-color: #0056b3;
            transform: scale(0.95);
        }
        .minus-btn {
            background-color: #6c757d;
            font-size: 16px;
            padding: 12px;
        }
        .minus-btn:active {
            background-color: #545b62;
        }
        .plus-btn {
            background-color: #28a745;
        }
        .plus-btn:active {
            background-color: #218838;
        }
        input[type="number"] {
            padding: 15px;
            font-size: 18px;
            border: 2px solid #ddd;
            border-radius: 8px;
            text-align: center;
            -webkit-appearance: none;
        }
        input[type="number"]:focus {
            outline: none;
            border-color: #007bff;
        }
        .time-settings {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin: 20px 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .time-settings h3 {
            margin: 0 0 15px 0;
            color: #333;
            font-size: 18px;
            text-align: center;
        }
        .time-row {
            display: grid;
            grid-template-columns: 1fr;
            gap: 10px;
            margin-bottom: 15px;
        }
        .time-label {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
        }
        input[type="time"] {
            padding: 12px;
            font-size: 16px;
            border: 2px solid #ddd;
            border-radius: 8px;
            width: 100%;
            -webkit-appearance: none;
        }
        input[type="time"]:focus {
            outline: none;
            border-color: #007bff;
        }
        .time-display {
            font-size: 20px;
            font-weight: bold;
            color: #333;
            text-align: center;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 8px;
            margin-top: 5px;
        }
        .reset-section {
            text-align: center;
            margin-top: 20px;
            padding: 0 20px;
        }
        .reset-btn {
            background-color: #dc3545;
            padding: 12px 30px;
            font-size: 16px;
        }
        .reset-btn:active {
            background-color: #c82333;
        }
        /* Disable iOS zoom on input focus */
        @media screen and (max-width: 768px) {
            input[type="number"] {
                font-size: 16px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>BMX Race Tracker</h1>
        
        <div class="status-box at-gate">
            <h2>🏁 AT GATE</h2>
            <div class="moto-number" id="atGate">1</div>
            <div class="box-controls">
                <button class="minus-btn" onclick="changeGate(-1)">− 1</button>
                <button class="plus-btn" onclick="changeGate(1)">+ 1</button>
            </div>
            <div class="input-row">
                <input type="number" id="gateInput" placeholder="Jump to..." min="0" inputmode="numeric">
                <button onclick="setGate()">GO</button>
            </div>
        </div>
        
        <div class="status-box staging">
            <h2>📢 IN STAGING</h2>
            <div class="moto-number" id="inStaging">1</div>
            <div class="box-controls">
                <button class="minus-btn" onclick="changeStaging(-1)">− 1</button>
                <button class="plus-btn" onclick="changeStaging(1)">+ 1</button>
            </div>
            <div class="input-row">
                <input type="number" id="stagingInput" placeholder="Jump to..." min="1" inputmode="numeric">
                <button onclick="setStaging()">GO</button>
            </div>
        </div>
        
        <div class="time-settings">
            <h3>⏰ Race Times</h3>
            <div class="time-row">
                <div class="time-label">Registration Deadline:</div>
                <input type="time" id="registrationTime" onchange="updateTimes()">
                <div class="time-display" id="registrationDisplay">Not Set</div>
            </div>
            <div class="time-row">
                <div class="time-label">Race Start Time:</div>
                <input type="time" id="startTime" onchange="updateTimes()">
                <div class="time-display" id="startDisplay">Not Set</div>
            </div>
        </div>
        
        <div class="reset-section">
            <button class="reset-btn" onclick="resetTracker()">Reset All</button>
        </div>
    </div>

    <script>
        let gateNumber = 0;
        let stagingNumber = 1;
        let registrationTime = '';
        let startTime = '';

        function updateDisplay() {
            document.getElementById('atGate').textContent = gateNumber;
            document.getElementById('inStaging').textContent = stagingNumber;
        }

        function updateTimes() {
            registrationTime = document.getElementById('registrationTime').value;
            startTime = document.getElementById('startTime').value;
            
            // Update display
            if (registrationTime) {
                const regTime = formatTime(registrationTime);
                document.getElementById('registrationDisplay').textContent = regTime;
            } else {
                document.getElementById('registrationDisplay').textContent = 'Not Set';
            }
            
            if (startTime) {
                const raceTime = formatTime(startTime);
                document.getElementById('startDisplay').textContent = raceTime;
            } else {
                document.getElementById('startDisplay').textContent = 'Not Set';
            }
            
            // Save to localStorage
            localStorage.setItem('bmx-registration-time', registrationTime);
            localStorage.setItem('bmx-start-time', startTime);
        }

        function formatTime(timeString) {
            if (!timeString) return 'Not Set';
            const [hours, minutes] = timeString.split(':');
            const hour = parseInt(hours);
            const ampm = hour >= 12 ? 'PM' : 'AM';
            const displayHour = hour % 12 || 12;
            return `${displayHour}:${minutes} ${ampm}`;
        }

        function loadTimes() {
            const savedRegTime = localStorage.getItem('bmx-registration-time');
            const savedStartTime = localStorage.getItem('bmx-start-time');
            
            if (savedRegTime) {
                document.getElementById('registrationTime').value = savedRegTime;
                registrationTime = savedRegTime;
            }
            if (savedStartTime) {
                document.getElementById('startTime').value = savedStartTime;
                startTime = savedStartTime;
            }
            
            updateTimes();
        }

        function changeGate(delta) {
            const newValue = gateNumber + delta;
            if (newValue >= 0 && newValue < stagingNumber) {
                gateNumber = newValue;
                updateDisplay();
            }
        }

        function changeStaging(delta) {
            const newValue = stagingNumber + delta;
            if (newValue > 0 && newValue > gateNumber) {
                stagingNumber = newValue;
                updateDisplay();
            }
        }

        function setGate() {
            const value = parseInt(document.getElementById('gateInput').value);
            if (!isNaN(value) && value >= 0 && value < stagingNumber) {
                gateNumber = value;
                updateDisplay();
                document.getElementById('gateInput').value = '';
            } else if (value >= stagingNumber) {
                alert('Gate number must be less than Staging number');
                document.getElementById('gateInput').value = '';
            }
        }

        function setStaging() {
            const value = parseInt(document.getElementById('stagingInput').value);
            if (value && value > 0 && value > gateNumber) {
                stagingNumber = value;
                updateDisplay();
                document.getElementById('stagingInput').value = '';
            } else if (value <= gateNumber) {
                alert('Staging number must be greater than Gate number');
                document.getElementById('stagingInput').value = '';
            }
        }

        function resetTracker() {
            if (confirm('Reset both counters?')) {
                gateNumber = 0;
                stagingNumber = 1;
                updateDisplay();
            }
        }

        // Allow Enter key for inputs
        document.getElementById('gateInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                setGate();
            }
        });
        
        document.getElementById('stagingInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                setStaging();
            }
        });

        // Initialize display
        updateDisplay();
    </script>
</body>
</html>

```
