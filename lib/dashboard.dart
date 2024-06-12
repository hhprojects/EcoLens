import 'package:eco_lens_draft/constants.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  items([count, title]) {
    return Container(
      margin: const EdgeInsets.only(left: 30, top: 35),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  itemsMenuList(Icon icon, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        child: ListTile(
          leading: icon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          tileColor: const Color(0xffe1e6ef),
          title: Text(
            text,
            style: TextStyle(color: backgroundColor),
          ),
          dense: true,
        ),
        onTap: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              //--! Title App !--\
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 30, bottom: 30),
                alignment: Alignment.topLeft,
                child: const Text(
                  'EcoLens',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
              ),
              Container(
                height: 175,
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xff3977ff),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                        20), //                 <--- border radius here
                  ),
                ),
                child: Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //--! Account Profile Image !--\\
                            Container(
                              height: 50,
                              width: 50,
                              margin: const EdgeInsets.only(left: 15, top: 20),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                      30), //                 <--- border radius here
                                ),
                              ),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  child: Container()),
                            ),
                            //--! Account name title !--\\
                            Container(
                              margin: const EdgeInsets.only(left: 10, top: 25),
                              child: const Text(
                                "Bob's Home Devices",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            items("84kg", "CO2e"),
                            items("\$40", "Electricity Consumption"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //--1 End Horizontal menu Scrollablle !--\\
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: true,
                child: Column(
                  children: [
                    itemsMenuList(
                        Icon(Icons.time_to_leave), "Samsung Washing Machine"),
                    itemsMenuList(Icon(Icons.wind_power), "Prism+ Aircon"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
