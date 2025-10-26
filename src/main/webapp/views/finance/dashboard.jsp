<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    com.sliit.pickmegoweb.model.User user = (com.sliit.pickmegoweb.model.User) session.getAttribute("user");
    if (user == null || !("Finance".equals(user.getRole()) || "Admin".equals(user.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finance Dashboard - PickMeGo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/design-system.css">
    <style>
        .finance-container { max-width: 1400px; margin: 0 auto; padding: 20px; }
        .page-header { background: linear-gradient(135deg, #0a914b, #15b66f); color: white; padding: 24px; border-radius: 12px; margin-bottom: 24px; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 16px; margin-bottom: 24px; }
        .stat-card { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.06); border-left: 4px solid #b7bfbf; }
        .stat-card h3 { margin: 0 0 6px 0; color: #334155; font-size: 0.95rem; }
        .stat-card .number { font-size: 2rem; font-weight: 700; color: #0f172a; }
        .data-table-container { background: white; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.06); overflow: hidden; }
        .table-header { background: #f8fafc; padding: 16px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; }
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table th, .data-table td { padding: 12px; text-align: left; border-bottom: 1px solid #f1f5f9; }
        .badge { padding: 4px 8px; border-radius: 999px; font-size: 12px; font-weight: 700; }
        .badge-completed { background: #dcfce7; color: #166534; }
        .badge-cancelled { background: #fee2e2; color: #991b1b; }
        .btn { padding: 10px 16px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; }
        .btn-refresh { background: #000c12; color: white; }
        .loading { text-align: center; padding: 32px; color: #64748b; }
        .no-data { text-align: center; padding: 32px; color: #94a3b8; }
    </style>
    <script>
        function getContextPath() { return "${pageContext.request.contextPath}"; }
        function formatCurrency(value) { return 'LKR ' + (value || 0).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }); }
        function loadSummary() {
            fetch(getContextPath() + '/FinanceServlet?action=summary')
                .then(r => r.json())
                .then(data => {
                    document.getElementById('totalRevenue').textContent = formatCurrency(data.totalRevenue);
                    document.getElementById('completedTrips').textContent = (data.completedTrips || 0);
                    document.getElementById('averageFare').textContent = formatCurrency(data.averageFare);
                    document.getElementById('todayRevenue').textContent = formatCurrency(data.todayRevenue);
                    document.getElementById('todayCompleted').textContent = (data.todayCompleted || 0);
                })
                .catch(() => {});
        }
        function loadCompletedTrips() {
            const container = document.getElementById('completedTripsTable');
            container.innerHTML = '<div class="loading"><i class="fas fa-spinner fa-spin"></i> Loading...</div>';
            fetch(getContextPath() + '/FinanceServlet?action=completedTrips')
                .then(r => r.json())
                .then(trips => {
                    if (!trips || trips.length === 0) {
                        container.innerHTML = '<div class="no-data">No completed trips found.</div>';
                        return;
                    }
                    let html = '<table class="data-table"><thead><tr>' +
                        '<th>Trip #</th><th>Customer</th><th>Driver</th><th>Pickup</th><th>Drop-off</th><th>Vehicle</th><th>Price</th><th>Status</th><th>Completed</th>' +
                        '</tr></thead><tbody>';
                    trips.forEach(t => {
                        const id = t.tripId || t.TripID;
                        const cust = t.customerId || t.CustomerID;
                        const drv = t.driverId || t.DriverID || '-';
                        const pick = t.pickupLocation || t.PickupLocation || '-';
                        const drop = t.dropoffLocation || t.DropOffLocation || '-';
                        const veh = t.vehicleType || t.vehicle_type || '-';
                        const price = typeof t.price === 'number' ? t.price : (parseFloat(t.price||0) || 0);
                        const status = t.status || t.TripStatus || '-';
                        const completed = t.completionTime || t.CompletionTime || t.bookingTime || t.BookingTime;
                        const compText = completed ? new Date(completed).toLocaleString() : '-';
                        html += '<tr>' +
                            '<td>#' + id + '</td>' +
                            '<td>' + (cust || '-') + '</td>' +
                            '<td>' + (drv || '-') + '</td>' +
                            '<td>' + pick + '</td>' +
                            '<td>' + drop + '</td>' +
                            '<td>' + (veh || '-') + '</td>' +
                            '<td>' + formatCurrency(price) + '</td>' +
                            '<td><span class="badge ' + (String(status).toLowerCase()==='completed' ? 'badge-completed' : 'badge-cancelled') + '">' + status + '</span></td>' +
                            '<td>' + compText + '</td>' +
                        '</tr>';
                    });
                    html += '</tbody></table>';
                    container.innerHTML = html;
                })
                .catch(() => { container.innerHTML = '<div class="no-data">Failed to load data.</div>'; });
        }
        function savePricing(){
            const vehicleType = document.getElementById('pricingVehicleType').value;
            const basePrice = document.getElementById('basePrice').value;
            const pricePerKm = document.getElementById('pricePerKm').value;
            const body = new URLSearchParams({ action:'upsertPricing', vehicleType, basePrice, pricePerKm });
            fetch(getContextPath() + '/FinanceServlet', { method:'POST', body })
                .then(r=>r.json()).then(_=>loadPricing());
        }
        function loadPricing(){
            fetch(getContextPath() + '/FinanceServlet?action=listPricing')
                .then(r=>r.json()).then(rows=>{
                    if(!rows || rows.length===0){ document.getElementById('pricingTable').innerHTML = '<div class="no-data">No pricing rules yet.</div>'; return; }
                    let html = '<table class="data-table"><thead><tr><th>Vehicle</th><th>Base</th><th>Per Km</th></tr></thead><tbody>';
                    rows.forEach(p=>{ html += '<tr><td>'+p.vehicleType+'</td><td>'+formatCurrency(p.basePrice)+'</td><td>'+formatCurrency(p.pricePerKm)+'</td></tr>'; });
                    html += '</tbody></table>';
                    document.getElementById('pricingTable').innerHTML = html;
                });
        }
        function createOffer(){
            const title = document.getElementById('offerTitle').value;
            const description = document.getElementById('offerDesc').value;
            const discountType = document.getElementById('discountType').value;
            const discountValue = document.getElementById('discountValue').value;
            const vehicleType = document.getElementById('offerVehicleType').value;
            const body = new URLSearchParams({ action:'createOffer', title, description, discountType, discountValue, vehicleType });
            fetch(getContextPath() + '/FinanceServlet', { method:'POST', body })
                .then(r=>r.json()).then(_=>{ alert('Offer created'); loadOffersAdmin(); });
        }
        function loadOffersAdmin(){
            fetch(getContextPath() + '/FinanceServlet?action=listOffers')
                .then(r=>r.json()).then(rows=>{
                    if(!rows || rows.length===0){ document.getElementById('offersAdminTable').innerHTML = '<div class="no-data">No active offers.</div>'; return; }
                    let html = '<table class="data-table"><thead><tr><th>#</th><th>Code</th><th>Type</th><th>Value</th><th>Expiry</th><th></th></tr></thead><tbody>';
                    rows.forEach(o=>{
                        const val = o.discountType === 'Percentage' ? (o.discountValue + '%') : ('LKR ' + o.discountValue);
                        const exp = o.expiresAt ? new Date(o.expiresAt).toLocaleDateString() : '-';
                        html += '<tr>'+
                            '<td>#'+o.id+'</td>'+
                            '<td>'+ (o.title||'') +'</td>'+
                            '<td>'+ (o.discountType||'') +'</td>'+
                            '<td>'+ val +'</td>'+
                            '<td>'+ exp +'</td>'+
                            '<td><button class="btn btn-refresh" onclick="deleteOffer('+o.id+')"><i class="fas fa-trash"></i> Delete</button></td>'+
                        '</tr>';
                    });
                    html += '</tbody></table>';
                    document.getElementById('offersAdminTable').innerHTML = html;
                });
        }
        function deleteOffer(id){
            if(!confirm('Delete this offer?')) return;
            const body = new URLSearchParams({ action:'deleteOffer', id:String(id) });
            fetch(getContextPath() + '/FinanceServlet', { method:'POST', body })
                .then(r=>r.json()).then(_=>loadOffersAdmin());
        }
        document.addEventListener('DOMContentLoaded', function() {
            loadSummary();
            loadCompletedTrips();
            loadPricing();
            loadOffersAdmin();
        });
    </script>
</head>
<body>
    <div class="finance-container">
        <div class="page-header">
            <div style="display:flex;justify-content:space-between;align-items:center;">
                <div>
                    <h1><i class="fas fa-sack-dollar"></i> Finance Dashboard</h1>
                    <p>Welcome, <%= user.getFirstName() %> <%= user.getLastName() %></p>
                </div>
                <a href="<%= request.getContextPath() %>/UserServlet?action=logout" style="color:white;text-decoration:none;">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Revenue</h3>
                <div class="number" id="totalRevenue">LKR 0.00</div>
            </div>
            <div class="stat-card">
                <h3>Completed Trips</h3>
                <div class="number" id="completedTrips">0</div>
            </div>
            <div class="stat-card">
                <h3>Average Fare</h3>
                <div class="number" id="averageFare">LKR 0.00</div>
            </div>
            <div class="stat-card">
                <h3>Today Revenue / Trips</h3>
                <div class="number"><span id="todayRevenue">LKR 0.00</span> / <span id="todayCompleted">0</span></div>
            </div>
        </div>

        <div class="data-table-container">
            <div class="table-header">
                <h3><i class="fas fa-receipt"></i> Completed Trips</h3>
                <button class="btn btn-refresh" onclick="loadSummary();loadCompletedTrips();"><i class="fas fa-sync-alt"></i> Refresh</button>
            </div>
            <div id="completedTripsTable">
                <div class="loading"><i class="fas fa-spinner fa-spin"></i> Loading...</div>
            </div>
        </div>

        <div class="data-table-container" style="margin-top:16px;">
            <div class="table-header">
                <h3><i class="fas fa-tags"></i> Create Offer</h3>
            </div>
            <div style="padding:16px; display:grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap:12px;">
                <input id="offerTitle" placeholder="Title" />
                <input id="offerDesc" placeholder="Description" />
                <select id="discountType"><option value="PERCENT">Percent %</option><option value="FIXED">Fixed LKR</option></select>
                <input id="discountValue" type="number" min="0" step="0.01" placeholder="Value" />
                <input id="offerVehicleType" placeholder="Vehicle Type (optional)" />
                <button class="btn btn-refresh" onclick="createOffer()"><i class="fas fa-paper-plane"></i> Send Offer</button>
            </div>
        </div>

        <div class="data-table-container" style="margin-top:16px;">
            <div class="table-header">
                <h3><i class="fas fa-money-bill"></i> Pricing Rules</h3>
            </div>
            <div style="padding:16px; display:grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap:12px;">
                <input id="pricingVehicleType" placeholder="Vehicle Type e.g., car, tuk tuk" />
                <input id="basePrice" type="number" min="0" step="0.01" placeholder="Base Price (LKR)" />
                <input id="pricePerKm" type="number" min="0" step="0.01" placeholder="Price per Km (LKR)" />
                <button class="btn btn-refresh" onclick="savePricing()"><i class="fas fa-save"></i> Save</button>
            </div>
            <div id="pricingTable" style="padding:16px;"></div>
        </div>
        <div class="data-table-container" style="margin-top:16px;">
            <div class="table-header">
                <h3><i class="fas fa-list"></i> Active Offers</h3>
                <button class="btn btn-refresh" onclick="loadOffersAdmin()"><i class="fas fa-sync-alt"></i> Refresh</button>
            </div>
            <div id="offersAdminTable" style="padding:16px;"></div>
        </div>
    </div>
</body>
</html>


