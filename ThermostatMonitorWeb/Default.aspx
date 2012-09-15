﻿<%@ Page Title="Thermostat Monitor - Track usage of WiFi Enabled Thermostats" Language="C#" MasterPageFile="~/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default"  %>
<%@ Register src="Controls/SlideShow.ascx" tagname="SlideShow" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link rel="stylesheet" href="/slides/agile_carousel.css" type='text/css'>
    <script src="/slides/agile_carousel.a1.1.min.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <uc1:SlideShow ID="SlideShow1" runat="server" />
    <br />
    <h1>Introducing Thermostat Monitor</h1>
    
    <h2>Completely Open</h2>
    <p>Thermostat Monitor is completely open.  You can use the website for free or you can download the source code and host your own copy.  You can also export your data in CSV format.</p>
    
</asp:Content>
