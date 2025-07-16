//= require active_admin/base

// Dashboard Charts JavaScript
document.addEventListener('DOMContentLoaded', function() {
  // Only run dashboard code if we're on the dashboard page
  if (!document.getElementById('salesChart')) return;

  // Get data from dashboard page (will be set by the dashboard)
  const dashboardData = window.dashboardData || {};
  
  if (dashboardData.salesData) {
    // Sales Over Time Chart
    const salesCtx = document.getElementById('salesChart').getContext('2d');
    new Chart(salesCtx, {
      type: 'line',
      data: {
        labels: dashboardData.salesData.labels,
        datasets: [{
          label: 'Daily Sales ($)',
          data: dashboardData.salesData.values,
          borderColor: 'rgb(75, 192, 192)',
          backgroundColor: 'rgba(75, 192, 192, 0.2)',
          tension: 0.1,
          fill: true
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: true,
            position: 'top'
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              callback: function(value) {
                return '$' + value.toLocaleString();
              }
            }
          }
        }
      }
    });
  }

  if (dashboardData.orderStatusData) {
    // Order Status Chart
    const statusCtx = document.getElementById('orderStatusChart').getContext('2d');
    new Chart(statusCtx, {
      type: 'doughnut',
      data: {
        labels: dashboardData.orderStatusData.labels,
        datasets: [{
          data: dashboardData.orderStatusData.values,
          backgroundColor: [
            '#FF6384',
            '#36A2EB',
            '#FFCE56',
            '#4BC0C0',
            '#9966FF'
          ]
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom'
          }
        }
      }
    });
  }

  if (dashboardData.topProductsData) {
    // Top Products Chart
    const productsCtx = document.getElementById('topProductsChart').getContext('2d');
    new Chart(productsCtx, {
      type: 'bar',
      data: {
        labels: dashboardData.topProductsData.labels,
        datasets: [{
          label: 'Total Sales ($)',
          data: dashboardData.topProductsData.values,
          backgroundColor: 'rgba(54, 162, 235, 0.8)',
          borderColor: 'rgba(54, 162, 235, 1)',
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            callbacks: {
              title: function(context) {
                return dashboardData.topProductsData.fullNames[context[0].dataIndex];
              },
              label: function(context) {
                return 'Sales: $' + context.parsed.y.toLocaleString();
              }
            }
          }
        },
        scales: {
          x: {
            ticks: {
              maxRotation: 45,
              minRotation: 45
            }
          },
          y: {
            beginAtZero: true,
            ticks: {
              callback: function(value) {
                return '$' + value.toLocaleString();
              }
            }
          }
        }
      }
    });
  }

  if (dashboardData.monthlyRevenueData) {
    // Monthly Revenue Chart
    const revenueCtx = document.getElementById('revenueChart').getContext('2d');
    new Chart(revenueCtx, {
      type: 'line',
      data: {
        labels: dashboardData.monthlyRevenueData.labels,
        datasets: [{
          label: 'Monthly Revenue ($)',
          data: dashboardData.monthlyRevenueData.values,
          borderColor: 'rgb(255, 99, 132)',
          backgroundColor: 'rgba(255, 99, 132, 0.2)',
          tension: 0.1,
          fill: true
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: true,
            position: 'top'
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              callback: function(value) {
                return '$' + value.toLocaleString();
              }
            }
          }
        }
      }
    });
  }

  if (dashboardData.userGrowthData) {
    // User Growth Chart
    const userGrowthCtx = document.getElementById('userGrowthChart').getContext('2d');
    new Chart(userGrowthCtx, {
      type: 'bar',
      data: {
        labels: dashboardData.userGrowthData.labels,
        datasets: [{
          label: 'New Users',
          data: dashboardData.userGrowthData.values,
          backgroundColor: 'rgba(75, 192, 192, 0.8)',
          borderColor: 'rgba(75, 192, 192, 1)',
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              stepSize: 1
            }
          }
        }
      }
    });
  }
});
