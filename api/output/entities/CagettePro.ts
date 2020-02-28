import {
  Column,
  Entity,
  Index,
  JoinColumn,
  JoinTable,
  ManyToMany,
  ManyToOne,
  OneToMany,
  OneToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { PCatalog } from "./PCatalog";
import { Vendor } from "./Vendor";
import { CompanyCourse } from "./CompanyCourse";
import { MangopayCompany } from "./MangopayCompany";
import { PMessage } from "./PMessage";
import { PNotif } from "./PNotif";
import { PProduct } from "./PProduct";
import { PUserCompany } from "./PUserCompany";

@Index("CagettePro_vendorId", ["vendorId"], {})
@Index("CagettePro_demoCatalogId", ["demoCatalogId"], {})
@Entity("CagettePro", { schema: "db" })
export class CagettePro {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("int", { name: "vendorId" })
  vendorId: number;

  @Column("mediumblob", { name: "vatRates" })
  vatRates: Buffer;

  @Column("tinyint", { name: "freeCpro", width: 1 })
  freeCpro: boolean;

  @Column("tinyint", { name: "training", width: 1 })
  training: boolean;

  @Column("tinyint", { name: "active", width: 1 })
  active: boolean;

  @Column("tinyint", { name: "network", width: 1 })
  network: boolean;

  @Column("int", { name: "demoCatalogId", nullable: true })
  demoCatalogId: number | null;

  @Column("varchar", { name: "networkGroupIds", nullable: true, length: 512 })
  networkGroupIds: string | null;

  @Column("tinyint", { name: "captiveGroups", width: 1 })
  captiveGroups: boolean;

  @Column("tinyint", { name: "disabled", width: 1 })
  disabled: boolean;

  @ManyToOne(
    () => PCatalog,
    pCatalog => pCatalog.cagettePros,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "demoCatalogId", referencedColumnName: "id" }])
  demoCatalog: PCatalog;

  @ManyToOne(
    () => Vendor,
    vendor => vendor.cagettePros,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "vendorId", referencedColumnName: "id" }])
  vendor2: Vendor;

  @OneToMany(
    () => CompanyCourse,
    companyCourse => companyCourse.company
  )
  companyCourses: CompanyCourse[];

  @OneToOne(
    () => MangopayCompany,
    mangopayCompany => mangopayCompany.company
  )
  mangopayCompany: MangopayCompany;

  @OneToMany(
    () => PCatalog,
    pCatalog => pCatalog.company
  )
  pCatalogs: PCatalog[];

  @OneToMany(
    () => PMessage,
    pMessage => pMessage.company
  )
  pMessages: PMessage[];

  @OneToMany(
    () => PNotif,
    pNotif => pNotif.company
  )
  pNotifs: PNotif[];

  @OneToMany(
    () => PProduct,
    pProduct => pProduct.company
  )
  pProducts: PProduct[];

  @OneToMany(
    () => PUserCompany,
    pUserCompany => pUserCompany.company
  )
  pUserCompanies: PUserCompany[];

  @ManyToMany(
    () => Vendor,
    vendor => vendor.cagettePros2
  )
  @JoinTable({
    name: "PVendorCompany",
    joinColumns: [{ name: "companyId", referencedColumnName: "id" }],
    inverseJoinColumns: [{ name: "vendorId", referencedColumnName: "id" }],
    schema: "db"
  })
  vendors: Vendor[];
}
