﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
namespace ThermostatMonitorLib
{
    public partial class Snapshot
    {
        public static Snapshot LoadLastSnapshot(int thermostatId)
        {
            Snapshots result = Snapshots.LoadSnapshots("SELECT * FROM Snapshots where ThermostatId=@ThermostatId and startTime = (select MAX(StartTime) from Snapshots where ThermostatId=@ThermostatId)", CommandType.Text, new SqlParameter[] { new SqlParameter("@ThermostatId", thermostatId) });
            if (result.Count > 0) return result[0]; else return null;
        }

        public Hashtable GetSecondsPerHour(int timezoneOffset)
        {
            int startHour = StartTime.Hour;
            DateTime endTime = StartTime.AddSeconds(Seconds);
            int endHour = endTime.Hour;
            Hashtable result = new Hashtable();
            for (int i = startHour; i <= endHour; i++)
            {
                int seconds = 3600;
                if (i == endHour) seconds = endTime.Minute * 60 + endTime.Second;
                if (i == startHour) seconds = seconds - StartTime.Minute * 60 - StartTime.Second;

                int adjustedHour = i + timezoneOffset;
                if (adjustedHour < 0) adjustedHour = 24 - adjustedHour;
                if (adjustedHour > 23) adjustedHour = adjustedHour - 24;

                result.Add(adjustedHour, seconds);
            }
            return result;
        }

    }
}
