﻿using System.Threading.Tasks;
using Microsoft.AspNetCore.SignalR;

namespace EnerGov.Web.ClerksLicensing.Hubs {
    public class JobProgressHub : Hub {

        public async Task AssociateJob(string jobId) {
            await Groups.AddToGroupAsync(Context.ConnectionId, jobId);
        }

    }
}
