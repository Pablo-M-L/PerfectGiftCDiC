//
//  DateTools.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 29/7/21.
//

import Foundation

let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    //formatter.timeStyle = .medium
    return formatter
}()

func getStringFromDate(date: Date)-> String{
    print("string from date \(date)")
    let formatter3 = DateFormatter()
    //formatter3.timeZone = TimeZone(abbreviation: "GMT")
    formatter3.dateStyle = .short
    print("string from date en string \(formatter3.string(from: date))")
    return formatter3.string(from: date)
}

func addDayDatePicker(datePicker: Date)->Date{
    let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: datePicker)
    return nextDate ?? Date()
}

func addYearToData(initDate: Date)-> Date{
    let nextDate = Calendar.current.date(byAdding: .year, value: 1, to: initDate)
    return nextDate ?? Date()
}

func ObtenerMesActual()->Int{
    let calendar = Calendar.current
    
    //primero contamos el dia de inicio de la inversion
    let dateComponents = calendar.dateComponents([.month], from: Date())
    let mesEnNumero = dateComponents.month ?? 0
    return mesEnNumero
}


func getNextDayEvent(date: Date)-> Date{
    print("get next day date")
    print(date)
    let calendar = Calendar.current
    var firstDateComponents = DateComponents()
    
    //obtenemos la fecha del aniversario en el año actual.
    let dateComponents = calendar.dateComponents([.month, .day, .year], from: date)
    let dateComponentsCurrent = calendar.dateComponents([.month, .day, .year], from: Date())
    let mesEnNumero = dateComponents.month ?? 0
    let diaEnNumero = dateComponents.day ?? 0
    let diaActualEnNumero = dateComponentsCurrent.day ?? 0
    let añoActualEnNumero = dateComponentsCurrent.year ?? 1900
    let mesActualEnNumero = dateComponentsCurrent.month ?? 0
    
    

    firstDateComponents.day = diaEnNumero
    firstDateComponents.month = mesEnNumero
    
    print(mesEnNumero)
    print(diaEnNumero)
    print(mesActualEnNumero)
    print(diaActualEnNumero)
    print(añoActualEnNumero)
    if mesEnNumero > mesActualEnNumero{
        //si el mes actual es menor que el mes de la fecha a celebrar es que aun no ha cumplido la fecha.
        firstDateComponents.year = añoActualEnNumero
        
    }else if mesEnNumero < mesActualEnNumero{
        //si el mes actual es mayor que el mes de la fecha a celebrar  ya ha pasado y el siguiente
        //evento será el año que viene.
        firstDateComponents.year = añoActualEnNumero + 1
    }else if mesEnNumero == mesActualEnNumero{
        //si es el mismo mes hay que comprobar si ya ha pasado el dia del evento.
        if diaEnNumero <= diaActualEnNumero{
            //si el dia actual es mayor que el dia del evento, es que ya ha pasado y la fecha será para el año siguiente.
            firstDateComponents.year = añoActualEnNumero + 1
        }else{
            firstDateComponents.year = añoActualEnNumero
        }
    }

    //firstDateComponents.timeZone = TimeZone(abbreviation: "GMT")

    let firstDate = Calendar(identifier: Calendar.Identifier.gregorian).date(from: firstDateComponents)
    print("get nex day returned \(firstDate)")
    return firstDate ?? Date()
   
}

func diasQueFaltan(fechaInicio: String)->Int{
    print("dias que faltan")
    var diasQueFaltan = 0
    let dateStringFormatter = DateFormatter()
    dateStringFormatter.dateFormat = "yyyy-MM-dd"
    //fecha actual
    let date = Date()
    let fechaAc = dateStringFormatter.string(from: date)
    let diaActual = Int(fechaAc.suffix(2)) ?? 0
    let diaInicio = Int(fechaInicio.suffix(2)) ?? 0
    
    if diaInicio > diaActual{
        diasQueFaltan = diaInicio - diaActual
    }
    else if diaInicio < diaActual{
        diasQueFaltan = (30 - diaActual) + diaInicio
    }
    else if diaInicio == diaActual{
        diasQueFaltan = 0
    }
    return diasQueFaltan
}

func calcularDiasQueFaltan(dateEvent: Date)-> Int{
    print("calcular dias que faltan")
    print("Fecha")
    print(dateEvent)
    let calendar = Calendar.current
    
    let dias = Set<Calendar.Component>([.day])
    print("dias")
    print(dias)
    let result = calendar.dateComponents(dias, from: dateEvent as   Date,  to: Date() as Date)
    print("resul")
    print(result)
    let resultado = (result.day ?? 0) * -1
    print("resultado")
    print(resultado)
    if resultado < 0 {
        return 0
    }
    else{
        return resultado
    }

}

func calcularAnyosCumplidos(dateEvent: Date)-> Int{
    let calendar = Calendar.current
    
    let anyos = Set<Calendar.Component>([.year])
    let result = calendar.dateComponents(anyos, from: dateEvent as   Date,  to: Date() as Date)
    
    //calcula los años actuales, por eso se le suma 1, ya que hay que mostrar los años que cumplirá en el proximo cumple.
    let anyosQueCumplira = (result.year ?? 0) + 1
    return anyosQueCumplira
}
