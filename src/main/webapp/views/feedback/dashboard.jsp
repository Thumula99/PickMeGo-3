<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sliit.pickmegoweb.model.User" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !("Feedback".equals(user.getRole()) || "Admin".equals(user.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Manager - PickMeGo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/design-system.css">
    <style>
        body {
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: #fff;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }
        .header h1 {
            margin: 0 0 5px 0;
            font-size: 1.8rem;
            font-weight: 700;
        }
        .header .muted {
            color: #d1fae5;
            margin: 0;
            font-size: 0.9rem;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 16px;
            margin-bottom: 20px;
        }
        .card {
            background: #f8f9fa;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 20px;
            border-left: 4px solid #10b981;
        }
        .card .muted {
            color: #6b7280;
            font-size: 0.9rem;
            margin-bottom: 8px;
        }
        .number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #1f2937;
            margin: 0;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .table th, .table td {
            padding: 12px;
            border-bottom: 1px solid #e5e7eb;
            text-align: left;
        }
        .table th {
            background: #f9fafb;
            font-weight: 600;
            color: #374151;
        }
        .actions {
            display: flex;
            gap: 8px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.875rem;
            transition: all 0.2s ease;
        }
        .btn-refresh {
            background: #374151;
            color: white;
        }
        .btn-refresh:hover {
            background: #1f2937;
        }
        .muted {
            color: #6b7280;
        }

        /* Button Styles */
        .btn-success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            box-shadow: 0 2px 8px rgba(16, 185, 129, 0.3);
        }
        .btn-success:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            transform: translateY(-1px);
        }
        .btn-warning {
            background: #f59e0b;
            color: white;
        }
        .btn-warning:hover {
            background: #d97706;
        }
        .btn-danger {
            background: #ef4444;
            color: white;
        }
        .btn-danger:hover {
            background: #dc2626;
        }

        /* Notice badges */
        .badge {
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            display: inline-block;
        }
        .type-general { background: #dbeafe; color: #1e40af; }
        .type-maintenance { background: #fef3c7; color: #d97706; }
        .type-service { background: #d1fae5; color: #059669; }
        .type-emergency { background: #fecaca; color: #dc2626; }
        .priority-low { background: #d1fae5; color: #059669; }
        .priority-normal { background: #dbeafe; color: #1e40af; }
        .priority-high { background: #fef3c7; color: #d97706; }
        .priority-critical { background: #fecaca; color: #dc2626; }
        .status-active { background: #d1fae5; color: #059669; }
        .status-inactive { background: #fecaca; color: #dc2626; }
    </style>
    <script>
        function getContextPath(){ return "${pageContext.request.contextPath}"; }
        function loadSummary(){
            // derive from listAll
            fetch(getContextPath()+"/FeedbackServlet?action=listAll")
                .then(r=>r.json()).then(rows=>{
                const pending = rows.filter(f=> (f.status||'')==='Open').length;
                const resolved = rows.filter(f=> (f.status||'')==='Resolved').length;
                const ratings = rows.map(f=>f.rating).filter(x=>x!=null);
                const avg = ratings.length? (ratings.reduce((a,b)=>a+b,0)/ratings.length).toFixed(1) : '0.0';
                document.getElementById('pendingCount').textContent = String(pending);
                document.getElementById('resolvedCount').textContent = String(resolved);
                document.getElementById('avgRating').textContent = String(avg);
            });
        }
        function loadRecent(){ loadAll(); }
        function loadAll(){
            const el = document.getElementById('recentTable');
            el.innerHTML = '<div class="muted">Loading...</div>';
            fetch(getContextPath()+"/FeedbackServlet?action=listAll")
                .then(r=>r.json()).then(rows=>{
                if(!rows || rows.length===0){ el.innerHTML = '<div class="muted">No feedback yet.</div>'; return; }
                let html = '<table class="table"><thead><tr><th>#</th><th>Title</th><th>Rating</th><th>Status</th><th>Reply</th><th></th></tr></thead><tbody>';
                rows.forEach(f=>{
                    html += '<tr>'+
                        '<td>#'+f.id+'</td>'+
                        '<td>'+escapeHtml(f.title||'')+'</td>'+
                        '<td>'+(f.rating==null?'-':f.rating)+'</td>'+
                        '<td>'+(f.status||'')+'</td>'+
                        '<td>'+(f.reply?escapeHtml(f.reply):'-')+'</td>'+
                        '<td>'+
                        '<button class="btn btn-refresh" onclick="openReply('+f.id+')" style="margin-right:4px;">Reply/Update Status</button>'+
                        '<button class="btn btn-danger" onclick="deleteFb('+f.id+')">Delete</button>'+
                        '</td>'+
                        '</tr>';
                });
                html += '</tbody></table>';
                el.innerHTML = html;
            });
        }
        function openReply(id){
            const reply = prompt('Enter reply (leave blank to keep current):');
            if(reply===null) return;
            const status = prompt('Enter status: Pending, Resolved, Looking For It, Other', 'Pending');
            if(status===null) return;
            const body = new URLSearchParams({ action:'reply', id:String(id), reply, status });
            fetch(getContextPath()+"/FeedbackServlet", { method:'POST', body })
                .then(r=>r.json()).then(_=>{ loadAll(); loadSummary(); });
        }
        function deleteFb(id){
            if(!confirm('Delete this feedback?')) return;
            const body = new URLSearchParams({ action:'delete', id:String(id) });
            fetch(getContextPath()+"/FeedbackServlet", { method:'POST', body })
                .then(r=>r.json()).then(_=>{ loadAll(); loadSummary(); });
        }
        function escapeHtml(s){ return String(s).replace(/[&<>\"]/g, function(c){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','\"':'&quot;'}[c]); }); }

        // Notice Management Functions
        function loadNotices(){
            const el = document.getElementById('noticesTable');
            el.innerHTML = '<div class="muted">Loading notices...</div>';

            fetch(getContextPath()+"/AdminServlet?action=getAllNotices")
                .then(response => {
                    console.log('Response status:', response.status);
                    console.log('Response headers:', response.headers);

                    if (!response.ok) {
                        throw new Error('HTTP error! status: ' + response.status);
                    }

                    // Check if response is JSON
                    const contentType = response.headers.get('content-type');
                    if (!contentType || !contentType.includes('application/json')) {
                        throw new Error('Response is not JSON. Content-Type: ' + contentType);
                    }

                    return response.text(); // Get as text first
                })
                .then(text => {
                    console.log('Raw response length:', text.length);
                    console.log('Raw response first 200 chars:', text.substring(0, 200));

                    // Check if response starts with HTML
                    if (text.trim().startsWith('<!DOCTYPE') || text.trim().startsWith('<html')) {
                        console.error('Server returned HTML instead of JSON. This usually means:');
                        console.error('1. Database table does not exist');
                        console.error('2. Server error occurred');
                        console.error('3. Authentication issue');
                        el.innerHTML = '<div class="muted" style="color:red;">Server returned HTML instead of JSON. Please check:<br>1. Database table exists<br>2. Server logs for errors<br>3. User authentication</div>';
                        return;
                    }

                    try {
                        const response = JSON.parse(text);
                        console.log('Parsed response:', response);

                        // Check if it's an error response
                        if (response.success === false) {
                            console.error('Server returned error:', response.message);
                            el.innerHTML = '<div class="muted" style="color:red;">Server Error: ' + response.message + '</div>';
                            return;
                        }

                        // If it's an array of notices, display them
                        if (Array.isArray(response)) {
                            displayNotices(response);
                        } else {
                            console.error('Response is not an array:', response);
                            el.innerHTML = '<div class="muted" style="color:red;">Unexpected response format</div>';
                        }
                    } catch (parseError) {
                        console.error('JSON parse error:', parseError);
                        console.error('Response text:', text);
                        el.innerHTML = '<div class="muted" style="color:red;">Error parsing response. Check console for details.</div>';
                    }
                })
                .catch(error => {
                    console.error('Fetch error:', error);
                    el.innerHTML = '<div class="muted" style="color:red;">Error loading notices: ' + error.message + '</div>';
                });
        }

        function displayNotices(notices){
            const el = document.getElementById('noticesTable');
            if(!notices || notices.length===0){
                el.innerHTML = '<div class="muted">No notices created yet.</div>';
                return;
            }
            let html = '<table class="table"><thead><tr><th>#</th><th>Title</th><th>Type</th><th>Priority</th><th>Audience</th><th>Status</th><th>Created</th><th>Actions</th></tr></thead><tbody>';
            notices.forEach(n=>{
                const noticeId = n.NoticeID || n.noticeId;
                const title = n.Title || n.title;
                const noticeType = n.NoticeType || n.noticeType;
                const priority = n.Priority || n.priority;
                const targetAudience = n.TargetAudience || n.targetAudience;
                const isActive = n.IsActive !== undefined ? n.IsActive : n.isActive;
                const createdDate = n.CreatedDate || n.createdDate;

                const statusText = isActive ? 'Active' : 'Inactive';
                const statusClass = isActive ? 'status-active' : 'status-inactive';
                const priorityClass = 'priority-' + priority.toLowerCase();
                const typeClass = 'type-' + noticeType.toLowerCase();

                html += '<tr>'+
                    '<td>#'+noticeId+'</td>'+
                    '<td>'+(title.length > 30 ? title.substring(0, 30) + '...' : title)+'</td>'+
                    '<td><span class="badge '+typeClass+'">'+noticeType+'</span></td>'+
                    '<td><span class="badge '+priorityClass+'">'+priority+'</span></td>'+
                    '<td>'+targetAudience+'</td>'+
                    '<td><span class="badge '+statusClass+'">'+statusText+'</span></td>'+
                    '<td>'+(createdDate ? new Date(createdDate).toLocaleDateString() : 'N/A')+'</td>'+
                    '<td>'+
                    '<button class="btn btn-warning" onclick="toggleNoticeStatus('+noticeId+')" style="margin-right:4px;">Toggle</button>'+
                    '<button class="btn btn-danger" onclick="deleteNotice('+noticeId+')">Delete</button>'+
                    '</td>'+
                    '</tr>';
            });
            html += '</tbody></table>';
            el.innerHTML = html;
        }

        function openCreateNoticeModal(){
            const modal = document.getElementById('createNoticeModal');
            if (modal) {
                modal.style.display = 'block';
            }
        }

        function closeCreateNoticeModal(){
            document.getElementById('createNoticeModal').style.display = 'none';
            document.getElementById('createNoticeForm').reset();
        }

        function submitCreateNotice(){
            const form = document.getElementById('createNoticeForm');
            const formData = new URLSearchParams();

            formData.append('action', 'createNotice');
            formData.append('title', form.title.value);
            formData.append('message', form.message.value);
            formData.append('noticeType', form.noticeType.value);
            formData.append('priority', form.priority.value);
            formData.append('targetAudience', form.targetAudience.value);
            if(form.expiryDate.value){
                formData.append('expiryDate', form.expiryDate.value);
            }

            console.log('Submitting notice:', formData.toString());

            fetch(getContextPath()+"/AdminServlet", {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            })
                .then(response => {
                    console.log('Create notice response status:', response.status);
                    if (!response.ok) {
                        throw new Error('HTTP error! status: ' + response.status);
                    }
                    return response.text();
                })
                .then(text => {
                    console.log('Create notice raw response:', text);
                    try {
                        const data = JSON.parse(text);
                        if(data.success){
                            alert('Notice created successfully!');
                            closeCreateNoticeModal();
                            loadNotices();
                        } else {
                            alert('Error creating notice: ' + data.message);
                        }
                    } catch (parseError) {
                        console.error('JSON parse error:', parseError);
                        console.error('Response text:', text);
                        alert('Error parsing server response. Check console for details.');
                    }
                })
                .catch(error => {
                    console.error('Create notice error:', error);
                    alert('Error creating notice: ' + error.message);
                });
        }

        function toggleNoticeStatus(noticeId){
            if(confirm('Are you sure you want to toggle the status of this notice?')){
                const formData = new URLSearchParams();
                formData.append('action', 'toggleNoticeStatus');
                formData.append('noticeId', noticeId);

                fetch(getContextPath()+"/AdminServlet", {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData
                })
                    .then(r=>r.json()).then(data=>{
                    if(data.success){
                        alert('Notice status toggled successfully!');
                        loadNotices();
                    } else {
                        alert('Error toggling notice status: ' + data.message);
                    }
                });
            }
        }

        function deleteNotice(noticeId){
            if(confirm('Are you sure you want to delete this notice? This action cannot be undone.')){
                const formData = new URLSearchParams();
                formData.append('action', 'deleteNotice');
                formData.append('noticeId', noticeId);

                fetch(getContextPath()+"/AdminServlet", {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData
                })
                    .then(r=>r.json()).then(data=>{
                    if(data.success){
                        alert('Notice deleted successfully!');
                        loadNotices();
                    } else {
                        alert('Error deleting notice: ' + data.message);
                    }
                });
            }
        }

        document.addEventListener('DOMContentLoaded', function(){
            loadSummary();
            loadRecent();
            loadNotices();
        });
    </script>
</head>
<body>
<div class="container">
    <div class="header">
        <div style="display:flex;justify-content:space-between;align-items:center;width:100%;">
            <div style="flex:1;">
                <h1><i class="fas fa-comments"></i> Feedback Manager</h1>
                <p class="muted">Welcome, <%= user.getFirstName() %> <%= user.getLastName() %></p>
            </div>
            <div style="flex-shrink:0;margin-left:auto;">
                <a href="<%= request.getContextPath() %>/UserServlet?action=logout"
                   style="background: linear-gradient(135deg, #dc3545 0%, #a5061e 100%);
                          color: #fff;
                          text-decoration: none;
                          padding: 12px 24px;
                          border-radius: 8px;
                          font-weight: 600;
                          font-size: 14px;
                          transition: all 0.3s ease;
                          box-shadow: 0 3px 10px rgba(220, 53, 69, 0.3);
                          border: 2px solid #dc3545;
                          cursor: pointer;
                          display: inline-flex;
                          align-items: center;
                          gap: 8px;
                          white-space: nowrap;"
                   onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 5px 15px rgba(220, 53, 69, 0.5)'"
                   onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 3px 10px rgba(220, 53, 69, 0.3)'">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </div>

    <div class="grid">
        <div class="card"><div class="muted">Pending Feedback</div><div class="number" id="pendingCount">0</div></div>
        <div class="card"><div class="muted">Resolved Feedback</div><div class="number" id="resolvedCount">0</div></div>
        <div class="card"><div class="muted">Average Rating</div><div class="number" id="avgRating">0.0</div></div>
    </div>

    <!-- Notices Management Section -->
    <div class="card" style="margin-top:16px;">
        <div style="display:flex;justify-content:space-between;align-items:center;">
            <h3><i class="fas fa-bullhorn"></i> Notice Management</h3>
            <div>
                <button class="btn btn-success" onclick="openCreateNoticeModal()" style="margin-right:8px;">
                    <i class="fas fa-plus"></i> Create Notice
                </button>
                <button class="btn btn-refresh" onclick="loadNotices();loadSummary();loadRecent();">
                    <i class="fas fa-sync-alt"></i> Refresh
                </button>
            </div>
        </div>
        <div id="noticesTable" style="margin-top:10px;"></div>
    </div>

    <div class="card" style="margin-top:16px;">
        <div style="display:flex;justify-content:space-between;align-items:center;">
            <h3><i class="fas fa-inbox"></i> Recent Feedback</h3>
            <button class="btn btn-refresh" onclick="loadSummary();loadRecent();"><i class="fas fa-sync-alt"></i> Refresh</button>
        </div>
        <div id="recentTable" style="margin-top:10px;"></div>
    </div>
</div>

<!-- Create Notice Modal -->
<div id="createNoticeModal" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.5);z-index:9999;">
    <div style="position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);background:white;border-radius:10px;padding:20px;width:90%;max-width:500px;box-shadow:0 10px 30px rgba(0,0,0,0.3);">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;">
            <h3><i class="fas fa-bullhorn"></i> Create New Notice</h3>
            <button onclick="closeCreateNoticeModal()" style="background:none;border:none;font-size:20px;cursor:pointer;color:#666;">&times;</button>
        </div>
        <form id="createNoticeForm">
            <div style="margin-bottom:15px;">
                <label style="display:block;margin-bottom:5px;font-weight:600;">Title *</label>
                <input type="text" id="noticeTitle" name="title" required maxlength="200" placeholder="Enter notice title"
                       style="width:100%;padding:8px;border:1px solid #ddd;border-radius:6px;">
            </div>
            <div style="margin-bottom:15px;">
                <label style="display:block;margin-bottom:5px;font-weight:600;">Message *</label>
                <textarea id="noticeMessage" name="message" required maxlength="1000" rows="4" placeholder="Enter notice message"
                          style="width:100%;padding:8px;border:1px solid #ddd;border-radius:6px;"></textarea>
            </div>
            <div style="margin-bottom:15px;">
                <label style="display:block;margin-bottom:5px;font-weight:600;">Notice Type</label>
                <select id="noticeType" name="noticeType" style="width:100%;padding:8px;border:1px solid #ddd;border-radius:6px;">
                    <option value="General">General</option>
                    <option value="Maintenance">Maintenance</option>
                    <option value="Service">Service</option>
                    <option value="Emergency">Emergency</option>
                </select>
            </div>
            <div style="margin-bottom:15px;">
                <label style="display:block;margin-bottom:5px;font-weight:600;">Priority</label>
                <select id="noticePriority" name="priority" style="width:100%;padding:8px;border:1px solid #ddd;border-radius:6px;">
                    <option value="Low">Low</option>
                    <option value="Normal" selected>Normal</option>
                    <option value="High">High</option>
                    <option value="Critical">Critical</option>
                </select>
            </div>
            <div style="margin-bottom:15px;">
                <label style="display:block;margin-bottom:5px;font-weight:600;">Target Audience</label>
                <select id="targetAudience" name="targetAudience" style="width:100%;padding:8px;border:1px solid #ddd;border-radius:6px;">
                    <option value="All" selected>All Users</option>
                    <option value="Customers">Customers Only</option>
                    <option value="Drivers">Drivers Only</option>
                </select>
            </div>
            <div style="margin-bottom:20px;">
                <label style="display:block;margin-bottom:5px;font-weight:600;">Expiry Date (Optional)</label>
                <input type="datetime-local" id="expiryDate" name="expiryDate"
                       style="width:100%;padding:8px;border:1px solid #ddd;border-radius:6px;">
            </div>
            <div style="display:flex;gap:10px;justify-content:flex-end;">
                <button type="button" onclick="closeCreateNoticeModal()"
                        style="padding:8px 16px;border:1px solid #ddd;background:white;border-radius:6px;cursor:pointer;">Cancel</button>
                <button type="button" onclick="submitCreateNotice()"
                        style="padding:8px 16px;background:#10b981;color:white;border:none;border-radius:6px;cursor:pointer;">
                    <i class="fas fa-plus"></i> Create Notice
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>


