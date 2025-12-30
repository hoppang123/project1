<%@ page contentType="text/html; charset=UTF-8" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<style>
    body { padding-top: 30px; }
    .seat {
        width: 45px; height: 45px; margin: 3px;
        display: inline-flex;
        justify-content: center; align-items: center;
        border-radius: 6px;
        cursor: pointer;
        font-weight: bold;
    }
    .seat-free { background:#e8f5e9; border:1px solid #4caf50; }
    .seat-selected { background:#4caf50; color:white; }
    .seat-reserved { background:#ffebee; border:1px solid #c62828; color:#c62828; cursor:not-allowed; }
</style>
l>