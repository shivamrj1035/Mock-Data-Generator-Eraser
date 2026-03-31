import type { LocaleProfile } from "./types.js";

export interface LocaleContext {
  profile: LocaleProfile;
  region?: string;
  firstNamesMale: string[];
  firstNamesFemale: string[];
  lastNames: string[];
  cities: string[];
  regions: string[];
  companies: string[];
  familyNameSuffix: string;
  phoneCountryCode: string;
  educationOptions: string[];
}

const globalContext: LocaleContext = {
  profile: "global",
  firstNamesMale: ["Arjun", "Michael", "Daniel", "Rohan", "James", "Noah"],
  firstNamesFemale: ["Priya", "Emily", "Sophia", "Ava", "Ananya", "Emma"],
  lastNames: ["Patel", "Shah", "Smith", "Johnson", "Brown", "Gupta"],
  cities: ["Ahmedabad", "Mumbai", "New York", "Chicago", "London", "Toronto"],
  regions: ["West", "North", "Central", "South", "East"],
  companies: ["Infosys", "Acme Corp", "Tata Consultancy Services", "Globex", "TechNova", "BluePeak"],
  familyNameSuffix: "Family",
  phoneCountryCode: "+1",
  educationOptions: ["High School", "Bachelor's Degree", "Master's Degree", "PhD"],
};

const indiaContext: LocaleContext = {
  profile: "india",
  firstNamesMale: ["Arjun", "Rahul", "Vikram", "Kunal", "Dhruv", "Yash"],
  firstNamesFemale: ["Priya", "Ananya", "Kavya", "Sneha", "Riya", "Ishita"],
  lastNames: ["Patel", "Shah", "Mehta", "Joshi", "Trivedi", "Desai"],
  cities: ["Ahmedabad", "Surat", "Vadodara", "Rajkot", "Mumbai", "Pune"],
  regions: ["Gujarat", "Maharashtra", "Rajasthan", "Delhi", "Karnataka"],
  companies: ["Infosys", "TCS", "Reliance Industries", "Wipro", "HCL Technologies", "Mahindra"],
  familyNameSuffix: "Kutumb",
  phoneCountryCode: "+91",
  educationOptions: ["10th Pass", "12th Pass", "Bachelor of Commerce", "B.Tech", "MBA", "MCA"],
};

const usContext: LocaleContext = {
  profile: "us",
  firstNamesMale: ["Michael", "James", "Noah", "Liam", "Benjamin", "Jacob"],
  firstNamesFemale: ["Emily", "Olivia", "Sophia", "Ava", "Charlotte", "Mia"],
  lastNames: ["Smith", "Johnson", "Williams", "Brown", "Davis", "Miller"],
  cities: ["New York", "Chicago", "Austin", "Seattle", "Denver", "Atlanta"],
  regions: ["California", "Texas", "Florida", "Illinois", "Washington"],
  companies: ["Acme Corp", "BluePeak Systems", "Northstar Labs", "Pioneer Health", "Cedar Works", "Granite AI"],
  familyNameSuffix: "Family",
  phoneCountryCode: "+1",
  educationOptions: ["High School", "Associate Degree", "Bachelor's Degree", "Master's Degree", "MBA", "PhD"],
};

export function getLocaleContext(profile: LocaleProfile, region?: string): LocaleContext {
  const base = profile === "india" ? indiaContext : profile === "us" ? usContext : globalContext;
  return {
    ...base,
    region: region?.trim() || undefined,
  };
}
